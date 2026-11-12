import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tasklab_mobile/controllers/auth_controller.dart';
import 'package:tasklab_mobile/models/validators.dart';
import 'package:tasklab_mobile/screens/register_screen.dart';
import 'package:tasklab_mobile/screens/task_form_screen.dart';
import 'package:tasklab_mobile/services/api_client.dart';
import 'package:tasklab_mobile/services/task_service.dart';
import 'package:tasklab_mobile/services/token_storage.dart';
import 'package:tasklab_mobile/widgets/password_field.dart';

void main() {
  testWidgets('CT-03 — Mostrar e ocultar senha sem apagar o valor', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordField(
            key: const Key('login-password'),
            controller: controller,
            label: 'Senha',
            validator: Validators.password,
          ),
        ),
      ),
    );

    final field = find.descendant(
      of: find.byKey(const Key('login-password')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(field, 'SenhaSegura123');
    expect(tester.widget<EditableText>(field).obscureText, isTrue);

    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pumpAndSettle();
    expect(tester.widget<EditableText>(field).obscureText, isFalse);
    expect(controller.text, 'SenhaSegura123');

    await tester.tap(find.byTooltip('Ocultar senha'));
    await tester.pumpAndSettle();
    expect(tester.widget<EditableText>(field).obscureText, isTrue);
    expect(controller.text, 'SenhaSegura123');
    controller.dispose();
  });

  testWidgets('CT-04 — Impede cadastro com campos obrigatórios vazios', (tester) async {
    var requests = 0;
    final api = ApiClient(
      client: MockClient((request) async {
        requests++;
        return http.Response('{}', 201);
      }),
      baseUrl: 'http://localhost',
    );
    final auth = AuthController(api, _MemoryTokenStorage());

    await tester.pumpWidget(
      MaterialApp(home: RegisterScreen(auth: auth)),
    );
    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pumpAndSettle();

    expect(requests, 0);
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.textContaining('informe'), findsNWidgets(3));
    expect(find.textContaining('Informe'), findsOneWidget);
    auth.dispose();
    api.close();
  });
  testWidgets('CT-06 — Cria tarefa com título e descrição vazia', (tester) async {
    http.Request? sentRequest;
    final api = ApiClient(
      client: MockClient((request) async {
        sentRequest = request;
        return http.Response(
          jsonEncode({
            'id': 42,
            'title': 'Estudar Flutter',
            'description': null,
            'completed': false,
            'created_at': '2026-01-01T10:00:00Z',
            'updated_at': '2026-01-01T10:00:00Z',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      }),
      baseUrl: 'http://localhost',
    )..token = 'token-de-teste';
    var result = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (_) => TaskFormScreen(service: TaskService(api)),
                      ),
                    ) ??
                    false;
              },
              child: const Text('Abrir formulário'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir formulário'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('task-title')), 'Estudar Flutter');
    await tester.tap(find.byKey(const Key('task-save')));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(sentRequest?.method, 'POST');
    expect(sentRequest?.url.path, '/tasks');
    expect(jsonDecode(sentRequest!.body), {
      'title': 'Estudar Flutter',
      'description': null,
    });
    api.close();
  });
}

class _MemoryTokenStorage implements TokenStorage {
  @override
  Future<String?> read() async => null;

  @override
  Future<void> write(String token) async {}

  @override
  Future<void> delete() async {}
}

