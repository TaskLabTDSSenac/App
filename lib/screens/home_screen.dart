import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tasks_controller.dart';
import '../theme/font_preference.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthController auth;
  final TasksController tasks;
  final FontPreference fontPreference;
  const HomeScreen({
    super.key,
    required this.auth,
    required this.tasks,
    required this.fontPreference,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Crônicas do Grimório'),
          Text(
            widget.auth.user?.name ?? '',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: IndexedStack(
        index: index,
        children: [
          TasksScreen(tasks: widget.tasks),
          ProfileScreen(
            auth: widget.auth,
            fontPreference: widget.fontPreference,
          ),
        ],
      ),
    ),
    floatingActionButton: index == 0
        ? FloatingActionButton.extended(
            key: const Key('task-create'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(service: widget.tasks.service),
                ),
              );
              if (mounted) await widget.tasks.refresh();
            },
            icon: const _QuillIcon(),
            label: const Text('Nova missão'),
          )
        : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.auto_stories_outlined),
          label: 'Missões',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Aventureiro',
        ),
      ],
    ),
  );
}

class _QuillIcon extends StatelessWidget {
  const _QuillIcon();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(24, 24),
    painter: _QuillPainter(Theme.of(context).colorScheme.onPrimary),
  );
}

class _QuillPainter extends CustomPainter {
  final Color color;

  const _QuillPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final feather = Path()
      ..moveTo(20, 3)
      ..cubicTo(11, 4, 5, 11, 3, 21)
      ..cubicTo(13, 20, 20, 12, 20, 3)
      ..close();
    canvas.drawPath(feather, paint);
    canvas.drawLine(const Offset(4, 20), const Offset(19, 4), paint);
    canvas.drawLine(const Offset(7, 16), const Offset(5, 13), paint);
    canvas.drawLine(const Offset(9, 14), const Offset(7, 11), paint);
    canvas.drawLine(const Offset(12, 11), const Offset(10, 8), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_QuillPainter oldDelegate) => oldDelegate.color != color;
}
