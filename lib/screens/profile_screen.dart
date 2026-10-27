import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../theme/app_theme.dart';
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
              Center(
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: const Icon(
                    Icons.sports_motorsports_rounded,
                    color: AppTheme.ink,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: SectionEyebrow(
                  'Equipe do box',
                  icon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Perfil do piloto',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              if (!AppConfig.profileEditingAvailable)
                const MessageBox(
                  'A edição de nome e e-mail ainda não está disponível. Nenhuma alteração será salva.',
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
              FilledButton.icon(
                key: const Key('profile-save'),
                onPressed: busy || !AppConfig.profileEditingAvailable
                    ? null
                    : save,
                icon: const Icon(Icons.save_outlined),
                label: Text(busy ? 'Salvando…' : 'Salvar dados'),
              ),
              TextButton.icon(
                key: const Key('profile-password'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangePasswordScreen(auth: widget.auth),
                  ),
                ),
                icon: const Icon(Icons.lock_reset_rounded, size: 18),
                label: const Text('Alterar senha'),
              ),
              OutlinedButton.icon(
                key: const Key('logout'),
                onPressed: () => widget.auth.logout(),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sair da conta'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Seu box. Seu ritmo. Sua estrada.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
