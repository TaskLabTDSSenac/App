import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasklab_mobile/widgets/password_field.dart';

void main() {
  testWidgets('CT-05 alterna a visibilidade da senha', (tester) async {
    final senha = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: PasswordField(
              controller: senha,
              label: 'Senha',
              validator: (_) => null,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'SenhaTeste123');
    final campo = find.descendant(
      of: find.byType(TextFormField),
      matching: find.byType(TextField),
    );
    expect(tester.widget<TextField>(campo).obscureText, isTrue);

    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(campo).obscureText, isFalse);

    await tester.tap(find.byTooltip('Ocultar senha'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(campo).obscureText, isTrue);

    senha.dispose();
  });
}
