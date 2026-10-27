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
  @override
  void initState() {
    super.initState();
    widget.tasks.refresh();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.tasks,
    builder: (context, _) {
      final state = widget.tasks;
      if (state.loading && state.tasks.isEmpty) return const LoadingView();
      final completed = state.tasks.where((task) => task.completed).length;

      return RefreshIndicator(
        color: AppTheme.graphite,
        backgroundColor: AppTheme.accent,
        onRefresh: state.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
          children: [
            _GarageBanner(total: state.tasks.length, completed: completed),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 22, 4, 4),
              child: Text(
                'Sua lista de serviços',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (state.loading) ...[
              const SizedBox(height: 10),
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  color: AppTheme.accent,
                  backgroundColor: Color(0xff303638),
                ),
              ),
            ],
            if (state.error != null) ...[
              MessageBox(state.error),
              FilledButton.icon(
                onPressed: state.refresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Tentar novamente'),
              ),
            ],
            if (!state.loading && state.error == null && state.tasks.isEmpty)
              const _EmptyGarage(),
            for (final task in state.tasks)
              TaskCard(
                key: ValueKey(task.id),
                task: task,
                service: state.service,
                refresh: state.refresh,
              ),
          ],
        ),
      );
    },
  );
}

class _GarageBanner extends StatelessWidget {
  final int total;
  final int completed;
  const _GarageBanner({required this.total, required this.completed});

  @override
  Widget build(BuildContext context) => Container(
    height: 190,
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xffe5ff69), AppTheme.accent, Color(0xffc5e92e)],
      ),
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          color: AppTheme.accent.withValues(alpha: .12),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 185,
              color: AppTheme.ink.withValues(alpha: .09),
            ),
          ),
          Positioned(
            right: 18,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 2,
                height: 88,
                decoration: BoxDecoration(
                  color: AppTheme.ink.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 54, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.speed_rounded,
                      size: 16,
                      color: AppTheme.ink,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'BOX 01  /  CENTRAL DE SERVIÇO',
                      style: TextStyle(
                        color: AppTheme.ink.withValues(alpha: .72),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Pronto para\na próxima volta?',
                  style: TextStyle(
                    color: AppTheme.ink,
                    fontSize: 25,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                Row(
                  children: [
                    _CountPill(label: 'TAREFAS', value: '$total'),
                    const SizedBox(width: 8),
                    _CountPill(label: 'CONCLUÍDAS', value: '$completed'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CountPill extends StatelessWidget {
  final String label;
  final String value;
  const _CountPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: AppTheme.ink.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.ink,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.ink.withValues(alpha: .72),
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: .65,
          ),
        ),
      ],
    ),
  );
}

class _EmptyGarage extends StatelessWidget {
  const _EmptyGarage();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: .28),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.car_repair_rounded,
              color: AppTheme.ink,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Garagem pronta para acelerar',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          const Text(
            'Adicione sua primeira tarefa e mantenha tudo em dia.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
