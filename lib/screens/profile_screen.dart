import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../widgets/common.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AuthController auth;
  const ProfileScreen({super.key, required this.auth});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  bool busy = false;
  String? message;
  bool success = false;
  @override
  void initState() {
    super.initState();
    name.text = widget.auth.user!.name;
    email.text = widget.auth.user!.email;
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      message = null;
      success = false;
    });
    try {
      await widget.auth.updateProfile(name.text, email.text);
      if (!mounted || widget.auth.user == null) return;
      name.text = widget.auth.user!.name;
      email.text = widget.auth.user!.email;
      setState(() {
        message = 'Dados atualizados com sucesso.';
        success = true;
      });
    } catch (e) {
      if (mounted) setState(() => message = friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PageBody(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Meu perfil',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (!AppConfig.profileEditingAvailable)
                const MessageBox(
                  'Edição de nome e e-mail pendente: a API ainda não oferece essa rota. Nenhuma alteração será salva.',
                ),
              MessageBox(message, success: success),
              TextFormField(
                initialValue: '${widget.auth.user?.id ?? ''}',
                readOnly: true,
                decoration: const InputDecoration(labelText: 'ID do usuário'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('profile-name'),
                controller: name,
                validator: Validators.name,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('profile-email'),
                controller: email,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('profile-save'),
                onPressed: busy || !AppConfig.profileEditingAvailable
                    ? null
                    : save,
                child: Text(busy ? 'Salvando…' : 'Salvar dados'),
              ),
              TextButton(
                key: const Key('profile-password'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangePasswordScreen(auth: widget.auth),
                  ),
                ),
                child: const Text('Alterar senha'),
              ),
              OutlinedButton(
                key: const Key('logout'),
                onPressed: () => widget.auth.logout(),
                child: const Text('Sair'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Projeto educacional inspirado no universo de Harry Potter.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
