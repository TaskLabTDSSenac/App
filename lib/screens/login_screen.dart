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
          const SizedBox(height: 12),
          const Brand(),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AutofillGroup(
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionEyebrow(
                        'Acesso do piloto',
                        icon: Icons.key_rounded,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sua garagem começa aqui.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Entre para acompanhar seus serviços e manter tudo pronto para a estrada.',
                        style: TextStyle(color: Color(0xff626a6c)),
                      ),
                      const SizedBox(height: 12),
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
                      FilledButton.icon(
                        key: const Key('login-submit'),
                        onPressed: widget.auth.busy
                            ? null
                            : () {
                                if (form.currentState!.validate()) {
                                  widget.auth.login(email.text, password.text);
                                }
                              },
                        icon: const Icon(Icons.login_rounded),
                        label: Text(
                          widget.auth.busy ? 'Entrando…' : 'Entrar na garagem',
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                    notice = 'Conta criada. Entre para acessar sua garagem.';
                                    password.clear();
                                  });
                                }
                              },
                        child: const Text('Novo por aqui? Criar conta'),
                      ),
                      if (widget.auth.message?.contains('apagar o token') ==
                          true)
                        TextButton(
                          onPressed: () => widget.auth.logout(),
                          child: const Text('Tentar limpar sessão novamente'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag_outlined, color: Colors.white38, size: 15),
              SizedBox(width: 8),
              Text(
                'UM BOX ORGANIZADO. UMA VIDA NA ESTRADA.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
