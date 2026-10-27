import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import '../widgets/common.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SessionScreen extends StatelessWidget {
  final AuthController auth;
  final TasksController tasks;
  const SessionScreen({super.key, required this.auth, required this.tasks});
  @override
  Widget build(BuildContext context) => switch (auth.phase) {
    AuthPhase.checking => const Scaffold(body: SafeArea(child: LoadingView())),
    AuthPhase.signedOut => LoginScreen(auth: auth),
    AuthPhase.authenticated => HomeScreen(
      key: ValueKey(auth.user!.id),
      auth: auth,
      tasks: tasks,
    ),
    AuthPhase.unavailable => Scaffold(
      appBar: AppBar(title: const Text('Verificar sessão')),
      body: Column(
        children: [
          Expanded(
            child: ErrorView(
              message: auth.message ?? 'Não foi possível validar sua sessão.',
              retry: auth.restore,
            ),
          ),
          SafeArea(
            child: TextButton(
              onPressed: () => auth.logout(),
              child: const Text('Sair desta sessão'),
            ),
          ),
        ],
      ),
    ),
  };
}
