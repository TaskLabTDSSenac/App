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
            const Text(
              'MINHA ROTA',
              style: TextStyle(
                fontFamily: 'TaskLabText',
                fontWeight: FontWeight.w700,
                fontSize: 27,
                color: Colors.white,
              ),
            ),
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null) ...[
              MessageBox(state.error),
              FilledButton(
                onPressed: state.refresh,
                child: const Text('Tentar novamente'),
              ),
            ],
            if (!state.loading && state.error == null && state.tasks.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Pista livre. Crie uma tarefa e dê a partida.'),
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
