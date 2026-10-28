import 'package:flutter/material.dart';
import '../controllers/tasks_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  final TasksController tasks;
  const TasksScreen({super.key, required this.tasks});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}
class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() { super.initState(); widget.tasks.refresh(); }
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.tasks,
    builder: (context, _) {
      final state = widget.tasks;
      if (state.loading && state.tasks.isEmpty) return const LoadingView();
      final done = state.tasks.where((task) => task.completed).length;
      final total = state.tasks.length;
      return RefreshIndicator(color: AppTheme.gold, onRefresh: state.refresh,
        child: ListView(physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(18, 10, 18, 108), children: [
          Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xff32283a), Color(0xff202b36), Color(0xff18343a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: .08))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('VICE CITY  /  CENTRAL DE OPERAÇÕES', style: TextStyle(color: AppTheme.cyan, fontSize: 10, letterSpacing: 1.7, fontWeight: FontWeight.w800)),
              const SizedBox(height: 11),
              const Text('Seu próximo\nmovimento começa aqui.', style: TextStyle(fontFamily: 'TaskLabTitle', fontSize: 24, height: 1.25, color: AppTheme.paper)),
              const SizedBox(height: 18),
              Row(children: [
                const Icon(Icons.bolt_rounded, color: AppTheme.gold, size: 19), const SizedBox(width: 7),
                Text('$done de $total objetivos concluídos', style: const TextStyle(color: Color(0xffe1dbe0), fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 10),
              ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(minHeight: 6,
                value: total == 0 ? 0 : done / total, backgroundColor: Colors.white.withValues(alpha: .13), color: AppTheme.pink)),
            ])),
          const SizedBox(height: 23),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('SUAS MISSÕES', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 12)),
            Text('$total ATIVAS', style: const TextStyle(color: Color(0xffaeb5bd), fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
          ]),
          if (state.loading) const LinearProgressIndicator(),
          if (state.error != null) ...[MessageBox(state.error), FilledButton(onPressed: state.refresh, child: const Text('Tentar novamente'))],
          if (!state.loading && state.error == null && state.tasks.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('Nenhuma missão por enquanto. Crie uma tarefa e comece a avançar.'))),
          for (final task in state.tasks) TaskCard(key: ValueKey(task.id), task: task, service: state.service, refresh: state.refresh),
        ]),
      );
    },
  );
}
