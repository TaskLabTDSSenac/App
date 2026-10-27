import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            label: Text(task.completed ? 'Concluída' : 'Pendente'),
            avatar: Icon(
              task.completed ? Icons.check : Icons.schedule,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(task.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            task.description ?? 'Sem descrição',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
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
            child: const Text('Abrir relatório'),
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
