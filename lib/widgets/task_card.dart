import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import '../screens/task_details_screen.dart';
import '../theme/app_theme.dart';
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
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: task.completed
                      ? const Color(0xffdcebd5)
                      : AppTheme.accent.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  task.completed
                      ? Icons.check_rounded
                      : Icons.build_circle_outlined,
                  color: AppTheme.ink,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.completed ? 'SERVIÇO CONCLUÍDO' : 'NA LISTA DE SERVIÇO',
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              if (task.completed)
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xff5b8a51),
                  size: 19,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(task.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            task.description?.trim().isNotEmpty == true
                ? task.description!
                : 'Sem descrição adicionada.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xff5e6669), height: 1.4),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
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
            icon: const Icon(Icons.article_outlined, size: 17),
            label: const Text('Ver ficha'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.ink,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          TaskActions(
            task: task,
            service: service,
            refresh: refresh,
            deleted: () {
              refresh();
            },
          ),
        ],
      ),
    ),
  );
}
