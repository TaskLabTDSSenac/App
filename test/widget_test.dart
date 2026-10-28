import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:tasklab_mobile/app.dart';
import 'package:tasklab_mobile/controllers/auth_controller.dart';
import 'package:tasklab_mobile/controllers/tasks_controller.dart';
import 'package:tasklab_mobile/services/api_client.dart';
import 'package:tasklab_mobile/services/task_service.dart';
import 'package:tasklab_mobile/widgets/task_actions.dart';

import 'api_test.dart' show MemoryStorage, jsonResponse, userJson, taskJson;

void main() {
  testWidgets('logout removes authenticated routes and clears tasks', (
    tester,
  ) async {
    final api = ApiClient(
      client: MockClient((request) async {
        if (request.url.path == '/users/me') return jsonResponse(userJson);
        return jsonResponse([taskJson]);
      }),
      baseUrl: 'https://api.example',
    );
    final auth = AuthController(api, MemoryStorage()..token = 'saved');
    final tasks = TasksController(auth, TaskService(api));
    await tester.pumpWidget(TaskLabApp(auth: auth, tasks: tasks));
    await tester.pumpAndSettle();
    expect(find.text('MINHA ROTA'), findsOneWidget);
    await tester.tap(find.byKey(const Key('task-create')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('task-save')), findsOneWidget);
    await auth.logout();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('task-save')), findsNothing);
    expect(find.byKey(const Key('login-email')), findsOneWidget);
    expect(tasks.tasks, isEmpty);
    final context = tester.element(find.byKey(const Key('login-email')));
    expect(Navigator.of(context).canPop(), false);
    await tester.pumpWidget(const SizedBox());
    tasks.dispose();
    auth.dispose();
    api.close();
  });
  testWidgets('initial login supports narrow screen and large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final api = ApiClient(
      client: MockClient((_) async => http.Response('{}', 500)),
      baseUrl: 'https://api.example',
    );
    final auth = AuthController(api, MemoryStorage());
    final tasks = TasksController(auth, TaskService(api));
    await tester.pumpWidget(TaskLabApp(auth: auth, tasks: tasks));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('login-email')), findsOneWidget);
    expect(find.text('SUA ROTA. SUAS REGRAS.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    tasks.dispose();
    auth.dispose();
    api.close();
  });
  testWidgets('delete requires confirmation and supports cancel', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await confirmTaskDeletion(context, 'Estudar poções');
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Estudar poções'), findsOneWidget);
    await tester.tap(find.byKey(const Key('delete-cancel')));
    await tester.pumpAndSettle();
    expect(result, false);
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete-confirm')));
    await tester.pumpAndSettle();
    expect(result, true);
  });
}
