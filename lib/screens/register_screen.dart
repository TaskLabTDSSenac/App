import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../widgets/common.dart';
import '../widgets/password_field.dart';

class RegisterScreen extends StatefulWidget {
  final AuthController auth;
  const RegisterScreen({super.key, required this.auth});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      confirmation = TextEditingController();
  bool busy = false;
  String? error;
  @override
  void dispose() {
    for (final field in [name, email, password, confirmation]) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.auth.auth.register(name.text, email.text, password.text);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Criar conta')),
    body: PageBody(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'A ESTRADA CHAMA',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                MessageBox(error),
                TextFormField(
                  key: const Key('register-name'),
                  controller: name,
                  validator: Validators.name,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('register-email'),
                  controller: email,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 16),
                PasswordField(
                  key: const Key('register-password'),
                  controller: password,
                  label: 'Senha',
                  validator: Validators.password,
                  newPassword: true,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  key: const Key('register-confirmation'),
                  controller: confirmation,
                  label: 'Confirmação de senha',
                  validator: (value) =>
                      Validators.confirmation(value, password.text),
                  newPassword: true,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  key: const Key('register-submit'),
                  onPressed: busy ? null : submit,
                  child: Text(busy ? 'Criando conta…' : 'Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
