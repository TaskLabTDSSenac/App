import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/auth_controller.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/common.dart';
import '../widgets/task_actions.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskService service;
  final int id;
  const TaskDetailsScreen({super.key, required this.service, required this.id});
  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Task? task;
  String? error;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final value = await widget.service.get(widget.id);
      if (mounted) setState(() => task = value);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Relatório da missão')),
    body: loading
        ? const LoadingView()
        : error != null
        ? ErrorView(message: error!, retry: load)
        : PageBody(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task!.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Chip(
                      label: Text(task!.completed ? 'Concluída' : 'Pendente'),
                    ),
                    SelectableText(task!.description ?? 'Sem descrição'),
                    const SizedBox(height: 24),
                    Text(
                      'Criada em: ${DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(task!.createdAt.toLocal())}',
                    ),
                    Text(
                      'Atualizada em: ${DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(task!.updatedAt.toLocal())}',
                    ),
                    const SizedBox(height: 16),
                    TaskActions(
                      task: task!,
                      service: widget.service,
                      refresh: load,
                      deleted: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ),
            ),
          ),
  );
}
