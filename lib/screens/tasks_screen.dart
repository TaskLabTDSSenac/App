import 'package:flutter/material.dart';

import '../controllers/tasks_controller.dart';
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
  void initState() {
    super.initState();
    widget.tasks.refresh();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.tasks,
    builder: (context, _) {
      final state = widget.tasks;
      if (state.loading && state.tasks.isEmpty) return const LoadingView();
      return RefreshIndicator(
        onRefresh: state.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xff282e35), Color(0xff14171b)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: const Color(0xff3c444d)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.speed_rounded, size: 42, color: Color(0xffe10600)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PRÓXIMA VOLTA', style: TextStyle(color: Color(0xffe53935), fontWeight: FontWeight.bold, letterSpacing: 1.4, fontSize: 12)),
                        SizedBox(height: 5),
                        Text('Suas tarefas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text('Organize o foco. Acelere nos resultados.', style: TextStyle(color: Colors.white60)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null) ...[
              MessageBox(state.error),
              FilledButton(onPressed: state.refresh, child: const Text('Tentar novamente')),
            ],
            if (!state.loading && state.error == null && state.tasks.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Pista livre! Adicione uma tarefa para começar sua próxima volta.'),
                ),
              ),
            for (final task in state.tasks)
              TaskCard(
                key: ValueKey(task.id),
                task: task,
                service: state.service,
                refresh: state.refresh,
              ),
          ],
        ),
      );
    },
  );
}
