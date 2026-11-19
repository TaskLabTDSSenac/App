import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tasklab_mobile/main.dart' as app;
import 'package:tasklab_mobile/services/token_storage.dart';
import 'package:tasklab_mobile/widgets/common.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CT-02 — Não permitir cadastro com senha inferior a 8 caracteres', (
    tester,
  ) async {
    // Preparação restrita ao teste: apaga só o token do TaskLab, não o dispositivo.
    await SecureTokenStorage().delete();
    await app.main();
    await aguardar(
      tester,
      () => find.byKey(const Key('login-email')).evaluate().isNotEmpty,
    );

    final abrirCadastro = find.text('Ainda não possui uma conta? Cadastre-se');
    await tester.ensureVisible(abrirCadastro);
    await tester.tap(abrirCadastro);
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );

    // Nome e e-mail válidos; somente a senha de seis caracteres viola o requisito.
    final email =
        'ct02-${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}@example.com';
    await preencher(tester, 'register-name', 'Aluno Teste');
    await preencher(tester, 'register-email', email);
    await preencher(tester, 'register-password', '123456');
    await preencher(tester, 'register-confirmation', '123456');

    // Fecha o teclado antes de rolar até o botão.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
    final cadastrar = find.byKey(const Key('register-submit'));
    await tester.ensureVisible(cadastrar);
    await tester.tap(cadastrar);

    const erroLocal = 'Senha: informe de 8 a 128 caracteres.';
    const erroApi = 'Senha: valor inválido ou fora dos limites permitidos.';
    const sucesso = 'Conta criada com sucesso. Faça login para continuar.';
    bool rejeitouSenha() =>
        find.text(erroLocal).evaluate().isNotEmpty ||
        find.text(erroApi).evaluate().isNotEmpty;
    bool mostrouErro() => tester
        .widgetList<MessageBox>(find.byType(MessageBox))
        .any((box) => !box.success && box.text != null);

    // Aguarda uma condição observável, com limite, em vez de dormir por tempo fixo.
    await aguardar(
      tester,
      () =>
          rejeitouSenha() ||
          mostrouErro() ||
          find.text(sucesso).evaluate().isNotEmpty ||
          find.byKey(const Key('login-email')).evaluate().isNotEmpty,
    );

    expect(
      find.text(sucesso),
      findsNothing,
      reason:
          'Defeito funcional: o aplicativo aceitou o cadastro com senha curta.',
    );
    expect(
      rejeitouSenha(),
      isTrue,
      reason:
          'É necessária uma rejeição relacionada à senha. Erro de conexão, '
          'servidor, e-mail ou permanência na tela não aprovam o CT-02.',
    );
    expect(cadastrar, findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 2)));

  testWidgets('CT-01 — Cadastrar usuário com sucesso', (tester) async {
    // Começa sem sessão e não depende do cadastro executado em outro teste.
    await SecureTokenStorage().delete();
    await app.main();
    await aguardar(
      tester,
      () => find.byKey(const Key('login-email')).evaluate().isNotEmpty,
    );

    final abrirCadastro = find.text('Ainda não possui uma conta? Cadastre-se');
    await tester.ensureVisible(abrirCadastro);
    await tester.tap(abrirCadastro);
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );

    // Dados válidos e e-mail exclusivo para evitar cadastro duplicado.
    const nome = 'Aluno Cadastro Valido';
    final email =
        'ct01-${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}@example.com';
    const senha = 'SenhaSegura123';
    await preencher(tester, 'register-name', nome);
    await preencher(tester, 'register-email', email);
    await preencher(tester, 'register-password', senha);
    await preencher(tester, 'register-confirmation', senha);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
    final cadastrar = find.byKey(const Key('register-submit'));
    await tester.ensureVisible(cadastrar);
    await tester.tap(cadastrar);

    // O formulário faz a requisição real; verificamos o resultado pela interface.
    const sucesso = 'Conta criada com sucesso. Faça login para continuar.';
    await aguardar(
      tester,
      () =>
          find.text(sucesso).evaluate().isNotEmpty ||
          tester
              .widgetList<MessageBox>(find.byType(MessageBox))
              .any((box) => !box.success && box.text != null),
    );
    expect(
      find.text(sucesso),
      findsOneWidget,
      reason:
          'O cadastro válido deve retornar ao login com mensagem de sucesso.',
    );
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
    expect(find.byKey(const Key('login-email')), findsOneWidget);
    final entrar = find.byKey(const Key('login-submit'));
    await tester.ensureVisible(entrar);
    expect(entrar.hitTestable(), findsOneWidget);
    expect(tester.widget<FilledButton>(entrar).onPressed, isNotNull);
    expect(cadastrar, findsNothing);
  }, timeout: const Timeout(Duration(minutes: 2)));
}

// Funciona tanto com TextFormField quanto com o componente PasswordField.
Future<void> preencher(WidgetTester tester, String key, String valor) async {
  final campo = find.byKey(Key(key));
  await tester.ensureVisible(campo);
  final entrada = find.descendant(
    of: campo,
    matching: find.byType(EditableText),
  );
  await tester.enterText(entrada, valor);
  await tester.pump();
}

Future<void> aguardar(WidgetTester tester, bool Function() pronto) async {
  final tempo = Stopwatch()..start();
  while (!pronto()) {
    if (tempo.elapsed > const Duration(seconds: 25)) {
      fail(
        'Tempo esgotado aguardando a interface. Confira inicialização, API, '
        'conexão e seletores antes de avaliar a regra de senha.',
      );
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}
