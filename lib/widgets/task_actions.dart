import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../exceptions/api_exception.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../screens/task_form_screen.dart';
import 'common.dart';

Future<bool> confirmTaskDeletion(BuildContext context, String title) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandonar missão?'),
        content: Text('O registro “$title” será removido permanentemente.'),
        actions: [
          TextButton(
            key: const Key('delete-cancel'),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('delete-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover registro'),
          ),
        ],
      ),
    ) ??
    false;

class TaskActions extends StatefulWidget {
  final Task task;
  final TaskService service;
  final Future<void> Function() refresh;
  final VoidCallback deleted;
  const TaskActions({
    super.key,
    required this.task,
    required this.service,
    required this.refresh,
    required this.deleted,
  });
  @override
  State<TaskActions> createState() => _TaskActionsState();
}

class _TaskActionsState extends State<TaskActions> {
  bool busy = false;
  Future<void> run(String action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      if (action == 'delete') {
        if (!await confirmTaskDeletion(context, widget.task.title) ||
            !mounted) {
          return;
        }
        await widget.service.delete(widget.task.id);
        if (mounted) widget.deleted();
      } else {
        try {
          await widget.service.complete(widget.task.id);
        } on ApiException catch (e) {
          if (e.status == 400) {
            if (mounted) showNotice(context, e.message);
            await widget.refresh();
            return;
          }
          rethrow;
        }
        if (mounted) showNotice(context, 'Missão concluída.');
        await widget.refresh();
      }
    } catch (e) {
      if (mounted) showNotice(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      TextButton(
        key: const Key('task-edit'),
        onPressed: busy
            ? null
            : () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskFormScreen(
                      service: widget.service,
                      id: widget.task.id,
                    ),
                  ),
                );
                if (mounted) await widget.refresh();
              },
        child: const Text('Editar'),
      ),
      if (!widget.task.completed)
        TextButton(
          key: const Key('task-complete'),
          onPressed: busy ? null : () => run('complete'),
          child: Text(busy ? 'Aguarde…' : 'Concluir missão'),
        ),
      TextButton(
        key: const Key('task-delete'),
        onPressed: busy ? null : () => run('delete'),
        child: const Text('Apagar'),
      ),
    ],
  );
}
