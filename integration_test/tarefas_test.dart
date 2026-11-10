import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tasklab_mobile/main.dart' as app;
import 'package:tasklab_mobile/services/token_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CT-06 — Criar tarefa com todos os campos preenchidos', (
    tester,
  ) async {
    await iniciarSessao(tester, 'ct06');

    final titulo = 'CT06 Tarefa ${DateTime.now().microsecondsSinceEpoch}';
    const descricao = 'Descricao completa da tarefa CT-06.';
    await criarTarefa(tester, titulo, descricao);

    expect(find.text(titulo), findsOneWidget);
    expect(find.text(descricao), findsOneWidget);
    expect(find.byKey(const Key('task-create')), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 3)));

  testWidgets('CT-10 — Editar uma tarefa existente', (tester) async {
    await iniciarSessao(tester, 'ct10');

    final tituloOriginal = 'CT10 Original ${DateTime.now().microsecondsSinceEpoch}';
    const descricaoOriginal = 'Descricao original para edicao.';
    await criarTarefa(tester, tituloOriginal, descricaoOriginal);

    final card = find.ancestor(
      of: find.text(tituloOriginal),
      matching: find.byType(Card),
    );
    final editar = find.descendant(
      of: card,
      matching: find.byKey(const Key('task-edit')),
    );
    await tester.ensureVisible(editar);
    await tester.tap(editar);
    await aguardar(
      tester,
      () => find.byKey(const Key('task-save')).evaluate().isNotEmpty &&
          campoTemValor(tester, 'task-title', tituloOriginal),
    );

    final tituloAtualizado = '$tituloOriginal Atualizada';
    await preencher(tester, 'task-title', tituloAtualizado);
    await salvar(tester);
    await aguardar(
      tester,
      () => find.text(tituloAtualizado).evaluate().isNotEmpty &&
          find.byKey(const Key('task-title')).evaluate().isEmpty &&
          find.byKey(const Key('task-create')).evaluate().isNotEmpty,
    );

    expect(find.text(tituloAtualizado), findsOneWidget);
    expect(find.text(tituloOriginal), findsNothing);
  }, timeout: const Timeout(Duration(minutes: 3)));

  testWidgets('CT-12 — Excluir uma tarefa existente', (tester) async {
    await iniciarSessao(tester, 'ct12');

    final titulo = 'CT12 Remover ${DateTime.now().microsecondsSinceEpoch}';
    await criarTarefa(tester, titulo, 'Tarefa preparada para exclusao.');

    final card = find.ancestor(
      of: find.text(titulo),
      matching: find.byType(Card),
    );
    final excluir = find.descendant(
      of: card,
      matching: find.byKey(const Key('task-delete')),
    );
    await tester.ensureVisible(excluir);
    await tester.tap(excluir);
    await aguardar(
      tester,
      () => find.byKey(const Key('delete-confirm')).evaluate().isNotEmpty,
    );
    await tester.tap(find.byKey(const Key('delete-confirm')));
    await aguardar(
      tester,
      () => find.text(titulo).evaluate().isEmpty ||
          find.byType(SnackBar).evaluate().isNotEmpty,
    );

    expect(
      find.text(titulo),
      findsNothing,
      reason:
          'A tarefa deveria desaparecer após a exclusão. '
          'Se uma mensagem de erro estiver visível, a API recusou a operação.',
    );
    expect(find.byKey(const Key('delete-confirm')), findsNothing);
    expect(find.byKey(const Key('task-create')), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 3)));
}

Future<void> iniciarSessao(WidgetTester tester, String prefixo) async {
  // Cada caso cria seu próprio usuário e não depende da sessão de outro teste.
  await SecureTokenStorage().delete();
  await app.main();
  await aguardar(
    tester,
    () => find.byKey(const Key('login-email')).evaluate().isNotEmpty,
  );

  await tester.ensureVisible(find.text('Novo por aqui? Criar conta'));
  await tester.tap(find.text('Novo por aqui? Criar conta'));
  await aguardar(
    tester,
    () => find.byKey(const Key('register-submit')).evaluate().isNotEmpty,
  );

  final email =
      '$prefixo-${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}@example.com';
  const senha = 'SenhaSegura123';
  await preencher(tester, 'register-name', 'Usuario Teste Tarefas');
  await preencher(tester, 'register-email', email);
  await preencher(tester, 'register-password', senha);
  await preencher(tester, 'register-confirmation', senha);
  await fecharTeclado(tester);
  final cadastrar = find.byKey(const Key('register-submit'));
  await tester.ensureVisible(cadastrar);
  await tester.tap(cadastrar);

  await aguardar(
    tester,
    () => find.byKey(const Key('login-email')).evaluate().isNotEmpty,
  );
  await preencher(tester, 'login-email', email);
  await preencher(tester, 'login-password', senha);
  await fecharTeclado(tester);
  final entrar = find.byKey(const Key('login-submit'));
  await tester.ensureVisible(entrar);
  await tester.tap(entrar);
  await aguardar(
    tester,
    () => find.byKey(const Key('task-create')).evaluate().isNotEmpty,
  );
}

Future<void> criarTarefa(
  WidgetTester tester,
  String titulo,
  String descricao,
) async {
  await tester.tap(find.byKey(const Key('task-create')));
  await aguardar(
    tester,
    () => find.byKey(const Key('task-save')).evaluate().isNotEmpty,
  );
  await preencher(tester, 'task-title', titulo);
  await preencher(tester, 'task-description', descricao);
  await salvar(tester);
  await aguardar(
    tester,
    () => find.text(titulo).evaluate().isNotEmpty &&
        find.byKey(const Key('task-title')).evaluate().isEmpty &&
        find.byKey(const Key('task-create')).evaluate().isNotEmpty,
  );
}

Future<void> salvar(WidgetTester tester) async {
  await fecharTeclado(tester);
  final botao = find.byKey(const Key('task-save'));
  await tester.ensureVisible(botao);
  await tester.tap(botao);
}

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

bool campoTemValor(WidgetTester tester, String key, String valor) {
  final campo = tester.widget<TextFormField>(find.byKey(Key(key)));
  return campo.controller?.text == valor;
}

Future<void> fecharTeclado(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 5),
  );
}

Future<void> aguardar(WidgetTester tester, bool Function() pronto) async {
  final tempo = Stopwatch()..start();
  while (!pronto()) {
    if (tempo.elapsed > const Duration(seconds: 25)) {
      fail(
        'Tempo esgotado aguardando a interface. Confira a API, a conexao, '
        'a inicializacao do aplicativo e os seletores do teste.',
      );
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}
