import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import '../theme/app_theme.dart';
import '../screens/task_details_screen.dart';
import 'task_actions.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskService service;
  final Future<void> Function() refresh;
  const TaskCard({
    super.key,
    required this.task,
    required this.service,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                task.completed
                    ? Icons.check_circle_outline
                    : Icons.schedule_rounded,
                color: task.completed ? const Color(0xff9bd2a9) : AppTheme.gold,
                size: 18,
              ),
              const SizedBox(width: 7),
              Text(
                task.completed ? 'Concluída' : 'Em andamento',
                style: TextStyle(
                  color: task.completed
                      ? const Color(0xff9bd2a9)
                      : AppTheme.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.auto_awesome,
                color: Color(0xff78633c),
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(task.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text(
            task.description?.trim().isNotEmpty == true
                ? task.description!
                : 'Este registro não possui detalhes adicionais.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white.withValues(alpha: .72)),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonalIcon(
              key: const Key('task-view'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TaskDetailsScreen(service: service, id: task.id),
                  ),
                );
                if (context.mounted) await refresh();
              },
              icon: const Icon(Icons.description_outlined),
              label: const Text('Abrir relatório'),
            ),
          ),
          const Divider(height: 24),
          TaskActions(
            task: task,
            service: service,
            refresh: refresh,
            deleted: refresh,
          ),
        ],
      ),
    ),
  );
}
