import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthController auth;
  final TasksController tasks;
  const HomeScreen({super.key, required this.auth, required this.tasks});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TaskLab'),
          Text(
            widget.auth.user?.name ?? '',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: IndexedStack(
        index: index,
        children: [
          TasksScreen(tasks: widget.tasks),
          ProfileScreen(auth: widget.auth),
        ],
      ),
    ),
    floatingActionButton: index == 0
        ? FloatingActionButton.extended(
            key: const Key('task-create'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(service: widget.tasks.service),
                ),
              );
              if (mounted) await widget.tasks.refresh();
            },
            icon: const Icon(Icons.add),
            label: const Text('Criar tarefa'),
          )
        : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.auto_stories_outlined),
          label: 'Tarefas',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    ),
  );
}
