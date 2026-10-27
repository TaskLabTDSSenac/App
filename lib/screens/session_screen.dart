import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SessionScreen extends StatelessWidget {
  final AuthController auth;
  final TasksController tasks;
  const SessionScreen({super.key, required this.auth, required this.tasks});

  @override
  Widget build(BuildContext context) => switch (auth.phase) {
    AuthPhase.checking => const Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Brand(), SizedBox(height: 36), LoadingView()],
        ),
      ),
    ),
    AuthPhase.signedOut => LoginScreen(auth: auth),
    AuthPhase.authenticated => HomeScreen(
      key: ValueKey(auth.user!.id),
      auth: auth,
      tasks: tasks,
    ),
    AuthPhase.unavailable => Scaffold(
      appBar: AppBar(title: const Text('Conexão da garagem')),
      body: Column(
        children: [
          Expanded(
            child: ErrorView(
              message: auth.message ?? 'Não foi possível validar sua sessão.',
              retry: auth.restore,
            ),
          ),
          SafeArea(
            child: TextButton.icon(
              onPressed: () => auth.logout(),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sair desta sessão'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.accent),
            ),
          ),
        ],
      ),
    ),
  };
}
