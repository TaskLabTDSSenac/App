import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/validators.dart';
import '../services/task_service.dart';
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
      title: Text(widget.id == null ? 'Criar tarefa' : 'Editar tarefa'),
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
                      Text(
                        'Uma nova parada na sua rota',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
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
                      FilledButton(
                        key: const Key('task-save'),
                        onPressed: busy ? null : save,
                        child: Text(busy ? 'Salvando…' : 'Salvar'),
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
