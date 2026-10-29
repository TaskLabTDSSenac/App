import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../widgets/common.dart';
import '../widgets/password_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final AuthController auth;
  const ChangePasswordScreen({super.key, required this.auth});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final form = GlobalKey<FormState>();
  final current = TextEditingController(),
      next = TextEditingController(),
      confirmation = TextEditingController();
  bool busy = false, success = false;
  String? message;
  @override
  void dispose() {
    for (final field in [current, next, confirmation]) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      success = false;
      message = null;
    });
    try {
      await widget.auth.users.changePassword(current.text, next.text);
      if (!mounted) return;
      current.clear();
      next.clear();
      confirmation.clear();
      setState(() {
        success = true;
        message = 'Senha alterada com sucesso.';
      });
    } catch (e) {
      if (mounted) setState(() => message = friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Proteger sua conta')),
    body: PageBody(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Escolha uma nova senha entre 8 e 128 caracteres.'),
                MessageBox(message, success: success),
                PasswordField(
                  key: const Key('password-current'),
                  controller: current,
                  label: 'Senha atual',
                  validator: Validators.currentPassword,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  key: const Key('password-new'),
                  controller: next,
                  label: 'Nova senha',
                  validator: Validators.password,
                  newPassword: true,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  key: const Key('password-confirmation'),
                  controller: confirmation,
                  label: 'Confirmação da nova senha',
                  validator: (value) =>
                      Validators.confirmation(value, next.text),
                  newPassword: true,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  key: const Key('password-submit'),
                  onPressed: busy ? null : save,
                  child: Text(busy ? 'Alterando…' : 'Alterar senha'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sua sessão continuará ativa. Tokens anteriores permanecem válidos até expirar.',
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
