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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: const BorderSide(color: Color(0xffc7a04b), width: 1.1),
    ),
    child: Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xff9a5366), width: 5)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, size: 18, color: Color(0xff716052)),
                const SizedBox(width: 8),
                Chip(
                  label: Text(task.completed ? 'Concluída' : 'Em andamento'),
                  avatar: Icon(
                    task.completed ? Icons.check : Icons.schedule,
                    size: 18,
                  ),
                ),
              ],
            ),
            const Divider(height: 12),
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
              child: const Text('Abrir pergaminho'),
            ),
            TaskActions(
              task: task,
              service: service,
              refresh: refresh,
              deleted: refresh,
            ),
          ],
        ),
      ),
    ),
  );
}
