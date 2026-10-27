import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../services/task_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskService service;
  final int? id;
  const TaskFormScreen({super.key, required this.service, this.id});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController(), description = TextEditingController();
  bool loading = false, busy = false;
  String? loadError, error;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) load();
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      loadError = null;
    });
    try {
      final task = await widget.service.get(widget.id!);
      if (!mounted) return;
      title.text = task.title;
      description.text = task.description ?? '';
    } catch (e) {
      if (mounted) setState(() => loadError = friendlyError(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.service.save(
        id: widget.id,
        title: title.text,
        description: description.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.id == null ? 'Nova tarefa' : 'Editar tarefa'),
    ),
    body: loading
        ? const LoadingView()
        : loadError != null
        ? ErrorView(message: loadError!, retry: load)
        : PageBody(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: .34),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.build_circle_outlined,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SectionEyebrow(
                        widget.id == null
                            ? 'Box 01  /  Nova entrada'
                            : 'Box 01  /  Atualização',
                        icon: Icons.home_repair_service_outlined,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.id == null
                            ? 'Adicionar serviço à lista'
                            : 'Atualizar tarefa da garagem',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Registre o que precisa ser feito e deixe tudo pronto para a próxima volta.',
                        style: TextStyle(color: Color(0xff626a6c)),
                      ),
                      const SizedBox(height: 20),
                      MessageBox(error),
                      TextFormField(
                        key: const Key('task-title'),
                        controller: title,
                        validator: Validators.title,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Título',
                          counterText: '${title.text.trim().runes.length}/150',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('task-description'),
                        controller: description,
                        validator: Validators.description,
                        maxLines: 6,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Descrição (opcional)',
                          counterText: '${description.text.runes.length}/500',
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        key: const Key('task-save'),
                        onPressed: busy ? null : save,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(busy ? 'Salvando…' : 'Salvar tarefa'),
                      ),
                      TextButton(
                        onPressed: busy ? null : () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
  );
}
