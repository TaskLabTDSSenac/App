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
      title: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTheme.gold.withValues(alpha: .14), borderRadius: BorderRadius.circular(11)),
          child: const Icon(Icons.bolt_rounded, color: AppTheme.gold)),
        const SizedBox(width: 11),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('TASKLAB', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
          Text(widget.auth.user?.name ?? '', style: const TextStyle(fontSize: 12, color: Color(0xffabb2bc))),
        ]),
      ]),
      actions: [Padding(padding: const EdgeInsets.only(right: 16), child: CircleAvatar(radius: 18,
        backgroundColor: AppTheme.pink.withValues(alpha: .18),
        child: Text((widget.auth.user?.name.isNotEmpty ?? false) ? widget.auth.user!.name[0].toUpperCase() : 'T',
          style: const TextStyle(color: AppTheme.pink, fontWeight: FontWeight.w800))))],
    ),
    body: SafeArea(child: IndexedStack(index: index, children: [TasksScreen(tasks: widget.tasks), ProfileScreen(auth: widget.auth)])),
    floatingActionButton: index == 0 ? FloatingActionButton.extended(
      key: const Key('task-create'),
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskFormScreen(service: widget.tasks.service)));
        if (mounted) await widget.tasks.refresh();
      },
      icon: const Icon(Icons.add_rounded), label: const Text('NOVA TAREFA')) : null,
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Painel'),
        NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
      ]),
  );
}
