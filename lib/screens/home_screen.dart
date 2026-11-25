import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'task_form_screen.dart';
import 'tasks_screen.dart';

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
  Widget build(BuildContext context) {
    final name = widget.auth.user?.name ?? '';
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        titleSpacing: 18,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_moon_outlined, color: AppTheme.gold, size: 27),
            SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARQUIVO JUJUTSU',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .7,
                  ),
                ),
                Text(
                  'Escola Técnica de Tóquio',
                  style: TextStyle(fontSize: 11, color: Colors.white60),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Tooltip(
                  message: name,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: width > 600 ? 220 : 48,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: width > 600 ? 11 : 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      border: Border.all(color: const Color(0xff39383b)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: AppTheme.gold,
                          size: 18,
                        ),
                        if (width > 600) ...[
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
              tooltip: 'Registrar uma nova missão',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TaskFormScreen(service: widget.tasks.service),
                  ),
                );
                if (mounted) await widget.tasks.refresh();
              },
              icon: const Icon(Icons.add),
              label: const Text('Nova missão'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            border: Border(top: BorderSide(color: Color(0xff39383b))),
          ),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            backgroundColor: AppTheme.surfaceDark,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            height: 72,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories_rounded),
                label: 'Missões',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Meu perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
