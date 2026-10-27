import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import '../theme/app_theme.dart';
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: AppTheme.ink,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PITLANE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
                Text(
                  'Olá, ${widget.auth.user?.name ?? 'piloto'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    body: SafeArea(
      top: false,
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
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nova tarefa'),
          )
        : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_repair_service_outlined),
          selectedIcon: Icon(Icons.home_repair_service_rounded),
          label: 'Garagem',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          selectedIcon: Icon(Icons.account_circle_rounded),
          label: 'Piloto',
        ),
      ],
    ),
  );
}
