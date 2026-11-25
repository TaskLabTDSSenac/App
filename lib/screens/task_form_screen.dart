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
      title: Text(widget.id == null ? 'Nova missão' : 'Editar missão'),
      actions: [
        IconButton(
          tooltip: 'Fechar formulário',
          onPressed: busy ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    ),
    body: loading
        ? const LoadingView()
        : loadError != null
        ? ErrorView(message: loadError!, retry: load)
        : PageBody(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            color: Color(0xffd4b35f),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Relatório de campo',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Preencha os dados da missão. O relatório é opcional.',
                      ),
                      MessageBox(error),
                      const SizedBox(height: 18),
                      TextFormField(
                        key: const Key('task-title'),
                        controller: title,
                        validator: (value) => Validators.taskTitle(
                          value,
                          editing: widget.id != null,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.sell_outlined),
                          labelText: 'Nome da missão *',
                          counterText: '${title.text.trim().runes.length}/150',
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        key: const Key('task-description'),
                        controller: description,
                        validator: Validators.description,
                        maxLines: 6,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 102),
                            child: Icon(Icons.notes_rounded),
                          ),
                          labelText: 'Detalhes do relatório (opcional)',
                          hintText:
                              'Descreva o que aconteceu e o contexto da missão',
                          counterText: '${description.text.runes.length}/500',
                        ),
                      ),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        key: const Key('task-save'),
                        onPressed: busy ? null : save,
                        icon: busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.archive_outlined),
                        label: Text(
                          busy
                              ? 'Salvando registro…'
                              : widget.id == null
                              ? 'Registrar missão'
                              : 'Salvar alterações',
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: busy ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                        label: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
  );
}
