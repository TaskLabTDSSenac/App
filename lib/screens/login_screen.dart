import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../widgets/common.dart';
import '../widgets/password_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthController auth;
  const LoginScreen({super.key, required this.auth});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  String? notice;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: PageBody(
      child: Column(
        children: [
          const Brand(),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AutofillGroup(
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Pronto para acelerar?',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Entre na sua conta e assuma o controle da pista.',
                      ),
                      MessageBox(notice, success: true),
                      MessageBox(widget.auth.message),
                      TextFormField(
                        key: const Key('login-email'),
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: Validators.email,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        key: const Key('login-password'),
                        controller: password,
                        label: 'Senha',
                        validator: Validators.currentPassword,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        key: const Key('login-submit'),
                        onPressed: widget.auth.busy
                            ? null
                            : () {
                                if (form.currentState!.validate()) {
                                  widget.auth.login(email.text, password.text);
                                }
                              },
                        child: Text(widget.auth.busy ? 'Entrandoâ€¦' : 'Entrar'),
                      ),
                      TextButton(
                        onPressed: widget.auth.busy
                            ? null
                            : () async {
                                final registered = await Navigator.of(context)
                                    .push<bool>(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            RegisterScreen(auth: widget.auth),
                                      ),
                                    );
                                if (mounted && registered == true) {
                                  setState(() {
                                    notice = 'Conta criada com sucesso. FaÃ§a login para continuar.';
                                    password.clear();
                                  });
                                }
                              },
                        child: const Text(
                          'Ainda nÃ£o possui uma conta? Cadastre-se',
                        ),
                      ),
                      if (widget.auth.message?.contains('apagar o token') ==
                          true)
                        TextButton(
                          onPressed: () => widget.auth.logout(),
                          child: const Text('Tentar limpar sessÃ£o novamente'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Seu painel de performance começa aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

