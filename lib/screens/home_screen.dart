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
      title: Row(
        children: [
          const Icon(Icons.sports_motorsports_rounded, color: Color(0xffe10600)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TASKLAB', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2.2)),
              Text(widget.auth.user?.name ?? '', style: const TextStyle(fontSize: 12, color: Colors.white60)),
            ],
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: IndexedStack(
        index: index,
        children: [TasksScreen(tasks: widget.tasks), ProfileScreen(auth: widget.auth)],
      ),
    ),
    floatingActionButton: index == 0
        ? FloatingActionButton.extended(
            key: const Key('task-create'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskFormScreen(service: widget.tasks.service)),
              );
              if (mounted) await widget.tasks.refresh();
            },
            icon: const Icon(Icons.add),
            label: const Text('Nova tarefa'),
          )
        : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.sports_score_outlined), selectedIcon: Icon(Icons.sports_score), label: 'Pista'),
        NavigationDestination(icon: Icon(Icons.person_pin_circle_outlined), selectedIcon: Icon(Icons.person_pin_circle), label: 'Piloto'),
      ],
    ),
  );
}
