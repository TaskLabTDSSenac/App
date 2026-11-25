import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tasklab_mobile/controllers/auth_controller.dart';
import 'package:tasklab_mobile/screens/login_screen.dart';
import 'package:tasklab_mobile/services/api_client.dart';
import 'package:tasklab_mobile/services/token_storage.dart';

class _MemoryTokenStorage implements TokenStorage {
  @override
  Future<String?> read() async => null;
  @override
  Future<void> write(String token) async {}
  @override
  Future<void> delete() async {}
}

AuthController _auth() => AuthController(
  ApiClient(
    client: MockClient((_) async => http.Response('{}', 500)),
    baseUrl: 'http://localhost',
  ),
  _MemoryTokenStorage(),
);

void main() {
  testWidgets('CT-04 abre a tela de cadastro pelo botão', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen(auth: _auth())));

    await tester.tap(find.text('Novo na rede? Crie seu acesso'));
    await tester.pumpAndSettle();

    expect(find.text('Criar conta'), findsOneWidget);
    expect(find.byKey(const Key('register-submit')), findsOneWidget);
  });
}
