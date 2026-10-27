import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/auth_controller.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../theme/app_theme.dart';
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
    appBar: AppBar(title: const Text('Ficha da tarefa')),
    body: loading
        ? const LoadingView()
        : error != null
        ? ErrorView(message: error!, retry: load)
        : PageBody(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withValues(alpha: .32),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.car_repair_rounded,
                            color: AppTheme.ink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SectionEyebrow(
                            task!.completed
                                ? 'Serviço concluído'
                                : 'Ficha de serviço',
                            icon: Icons.confirmation_number_outlined,
                          ),
                        ),
                        Icon(
                          task!.completed
                              ? Icons.check_circle_rounded
                              : Icons.pending_outlined,
                          color: task!.completed
                              ? const Color(0xff5b8a51)
                              : const Color(0xff8a732c),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      task!.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const SectionEyebrow('Descrição'),
                    const SizedBox(height: 8),
                    SelectableText(
                      task!.description?.trim().isNotEmpty == true
                          ? task!.description!
                          : 'Sem descrição adicionada.',
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xffe9ece6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _DateLine(
                            icon: Icons.add_circle_outline_rounded,
                            label: 'Criada em',
                            value: DateFormat(
                              'dd/MM/yyyy  •  HH:mm',
                              'pt_BR',
                            ).format(task!.createdAt.toLocal()),
                          ),
                          const SizedBox(height: 13),
                          _DateLine(
                            icon: Icons.update_rounded,
                            label: 'Última atualização',
                            value: DateFormat(
                              'dd/MM/yyyy  •  HH:mm',
                              'pt_BR',
                            ).format(task!.updatedAt.toLocal()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
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

class _DateLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DateLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: AppTheme.muted),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}
