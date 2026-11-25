import 'package:flutter/material.dart';

import '../controllers/tasks_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  final TasksController tasks;
  const TasksScreen({super.key, required this.tasks});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final search = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.tasks.refresh();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.tasks,
    builder: (context, _) {
      final state = widget.tasks;
      final query = search.text.trim().toLowerCase();
      final visibleTasks = state.tasks
          .where(
            (task) =>
                query.isEmpty ||
                task.title.toLowerCase().contains(query) ||
                (task.description ?? '').toLowerCase().contains(query),
          )
          .toList();

      if (state.loading && state.tasks.isEmpty) return const LoadingView();

      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: RefreshIndicator(
            onRefresh: state.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 112),
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xff321d20),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xff63373a)),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quadro de missões',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Registros oficiais da Escola Técnica de Tóquio',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  key: const Key('task-search'),
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.gold,
                    ),
                    labelText: 'Buscar missões',
                    hintText: 'Digite um título ou trecho do relatório',
                    suffixIcon: search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar busca',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              search.clear();
                              setState(() {});
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                if (state.loading) const LinearProgressIndicator(),
                if (state.error != null) ...[
                  MessageBox(state.error),
                  FilledButton.icon(
                    onPressed: state.refresh,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Tentar novamente'),
                  ),
                ],
                if (!state.loading &&
                    state.error == null &&
                    state.tasks.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff292319),
                              border: Border.all(
                                color: const Color(0xff705a34),
                              ),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: AppTheme.gold,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Seu arquivo está vazio',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'As missões cadastradas aparecerão aqui. Toque em “Nova missão” para registrar a primeira.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: AppTheme.gold,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'O botão está no canto inferior da tela',
                                style: TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (state.tasks.isNotEmpty && visibleTasks.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            color: AppTheme.gold,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Nenhuma missão corresponde à busca. Tente outro termo.',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              search.clear();
                              setState(() {});
                            },
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                for (final task in visibleTasks)
                  TaskCard(
                    key: ValueKey(task.id),
                    task: task,
                    service: state.service,
                    refresh: state.refresh,
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
