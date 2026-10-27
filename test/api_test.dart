import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tasklab_mobile/controllers/auth_controller.dart';
import 'package:tasklab_mobile/controllers/tasks_controller.dart';
import 'package:tasklab_mobile/exceptions/api_exception.dart';
import 'package:tasklab_mobile/models/user.dart';
import 'package:tasklab_mobile/models/task.dart';
import 'package:tasklab_mobile/models/validators.dart';
import 'package:tasklab_mobile/services/api_client.dart';
import 'package:tasklab_mobile/services/auth_service.dart';
import 'package:tasklab_mobile/services/task_service.dart';
import 'package:tasklab_mobile/services/token_storage.dart';

class MemoryStorage implements TokenStorage {
  String? token;
  bool fail = false;
  @override
  Future<String?> read() async {
    if (fail) throw Exception();
    return token;
  }

  @override
  Future<void> write(String value) async {
    if (fail) throw Exception();
    token = value;
  }

  @override
  Future<void> delete() async {
    if (fail) throw Exception();
    token = null;
  }
}

const userJson = {'id': 1, 'name': 'Ana', 'email': 'ana@example.com'};
final taskJson = {
  'id': 1,
  'title': 'Estudar',
  'description': null,
  'completed': false,
  'created_at': '2026-10-26T12:00:00Z',
  'updated_at': '2026-10-26T12:00:00Z',
};
http.Response jsonResponse(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);
ApiClient apiWith(Future<http.Response> Function(http.Request) fn) =>
    ApiClient(client: MockClient(fn), baseUrl: 'https://api.example');

void main() {
  test('models require real fields and parse UTC timestamps', () {
    expect(User.fromJson(userJson).name, 'Ana');
    final task = Task.fromJson(taskJson);
    expect(task.description, isNull);
    expect(task.createdAt.isUtc, isTrue);
    expect(() => User.fromJson({'id': 1}), throwsFormatException);
    expect(
      () => Task.fromJson({...taskJson, 'completed': 'false'}),
      throwsFormatException,
    );
    expect(
      () => Task.fromJson({...taskJson, 'created_at': 'invalid'}),
      throwsFormatException,
    );
  });
  test('login sends only email/password and no Bearer; UTF-8', () async {
    final api = apiWith((request) async {
      expect(request.headers.containsKey('Authorization'), isFalse);
      expect(jsonDecode(request.body), {
        'email': 'ana@example.com',
        'password': '  poção123  ',
      });
      return jsonResponse({'access_token': 'token', 'token_type': 'bearer'});
    });
    api.token = 'older';
    expect(
      await AuthService(api).login(' ana@example.com ', '  poção123  '),
      'token',
    );
    api.close();
  });
  test('login 401 does not expire another session', () async {
    final api = apiWith((_) async => jsonResponse({'detail': 'failure'}, 401));
    var expired = false;
    api.onUnauthorized = () => expired = true;
    await expectLater(
      AuthService(api).login('a@b.com', 'bad'),
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
    );
    expect(expired, isFalse);
    api.close();
  });
  test('204 success and protected Authorization', () async {
    final api = apiWith((r) async {
      expect(r.method, 'DELETE');
      expect(r.headers['Authorization'], 'Bearer token');
      return http.Response('', 204);
    })..token = 'token';
    expect(await api.request('DELETE', '/tasks/1'), isNull);
    api.close();
  });
  test('completion is PATCH complete without a body', () async {
    final api = apiWith((r) async {
      expect(r.method, 'PATCH');
      expect(r.url.path, '/tasks/1/complete');
      expect(r.body, isEmpty);
      return jsonResponse({...taskJson, 'completed': true});
    })..token = 'token';
    expect((await TaskService(api).complete(1)).completed, isTrue);
    api.close();
  });
  test('textual detail is preserved', () async {
    final api = apiWith(
      (_) async => jsonResponse({'detail': 'Senha atual incorreta.'}, 400),
    )..token = 't';
    await expectLater(
      api.request('PATCH', '/users/me/password'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Senha atual incorreta.',
        ),
      ),
    );
    api.close();
  });
  test('validation list hides input and internal errors', () async {
    final api = apiWith(
      (_) async => jsonResponse({
        'detail': [
          {
            'loc': ['body', 'password'],
            'input': 'secret',
            'msg': 'internal',
          },
        ],
      }, 422),
    )..token = 't';
    try {
      await api.request('POST', '/tasks');
      fail('expected error');
    } on ApiException catch (e) {
      expect(e.message, contains('Senha'));
      expect(e.message, isNot(contains('secret')));
      expect(e.message, isNot(contains('internal')));
    }
    api.close();
  });
  test('HTML response does not leak internal page', () async {
    final api = apiWith(
      (_) async => http.Response('<html>stack trace</html>', 500),
    )..token = 't';
    await expectLater(
      api.request('GET', '/tasks'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message.contains('<html>'),
          'no html',
          false,
        ),
      ),
    );
    api.close();
  });
  test('write timeout does not retry and reports uncertainty', () async {
    var calls = 0;
    final api = ApiClient(
      client: MockClient((_) async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return jsonResponse({});
      }),
      baseUrl: 'https://api.example',
      timeout: const Duration(milliseconds: 1),
    )..token = 't';
    await expectLater(
      api.request('POST', '/tasks'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          contains('confirmar'),
        ),
      ),
    );
    expect(calls, 1);
    api.close();
  });
  test('expired restored session clears token and user', () async {
    final storage = MemoryStorage()..token = 'expired';
    final api = apiWith((_) async => jsonResponse({}, 401));
    final auth = AuthController(api, storage);
    await auth.restore();
    await Future<void>.delayed(Duration.zero);
    expect(auth.phase, AuthPhase.signedOut);
    expect(auth.user, isNull);
    expect(storage.token, isNull);
    auth.dispose();
    api.close();
  });
  test('500 on restore preserves saved token and permits retry', () async {
    var status = 500;
    final storage = MemoryStorage()..token = 'saved';
    final api = apiWith((_) async => jsonResponse(userJson, status));
    final auth = AuthController(api, storage);
    await auth.restore();
    expect(auth.phase, AuthPhase.unavailable);
    expect(storage.token, 'saved');
    status = 200;
    await auth.restore();
    expect(auth.user!.name, 'Ana');
    auth.dispose();
    api.close();
  });
  test('late response cannot repopulate user after logout', () async {
    final result = Completer<http.Response>();
    final storage = MemoryStorage()..token = 'saved';
    final api = apiWith((_) => result.future);
    final auth = AuthController(api, storage);
    final restoring = auth.restore();
    await Future<void>.delayed(Duration.zero);
    await auth.logout();
    result.complete(jsonResponse(userJson));
    await restoring;
    expect(auth.user, isNull);
    expect(auth.phase, AuthPhase.signedOut);
    auth.dispose();
    api.close();
  });
  test('late tasks response is ignored after logout', () async {
    final pending = Completer<http.Response>();
    final storage = MemoryStorage()..token = 'saved';
    final api = apiWith(
      (r) async => r.url.path == '/users/me'
          ? jsonResponse(userJson)
          : await pending.future,
    );
    final auth = AuthController(api, storage);
    await auth.restore();
    final tasks = TasksController(auth, TaskService(api));
    final request = tasks.refresh();
    await Future<void>.delayed(Duration.zero);
    await auth.logout();
    pending.complete(jsonResponse([taskJson]));
    await request;
    expect(tasks.tasks, isEmpty);
    expect(tasks.loading, isFalse);
    tasks.dispose();
    auth.dispose();
    api.close();
  });
  test('storage failures yield recoverable session screen', () async {
    final api = apiWith((_) async => jsonResponse(userJson));
    final auth = AuthController(api, MemoryStorage()..fail = true);
    await auth.restore();
    expect(auth.phase, AuthPhase.unavailable);
    expect(auth.message, isNotEmpty);
    auth.dispose();
    api.close();
  });
  test('validators preserve passwords and enforce trimmed lengths', () {
    expect(Validators.name('  '), isNotNull);
    expect(Validators.name(' Ana '), isNull);
    expect(Validators.email('bad'), isNotNull);
    expect(Validators.email('a@b.com'), isNull);
    expect(Validators.title(' ab '), isNotNull);
    expect(Validators.title(' abc '), isNull);
    expect(Validators.description('x' * 501), isNotNull);
    expect(Validators.password('1234567'), isNotNull);
    expect(Validators.password(' 123456 '), isNull);
    expect(Validators.currentPassword('x'), isNull);
    expect(Validators.confirmation('password', ' password'), isNotNull);
  });
}
