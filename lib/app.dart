import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/tasks_controller.dart';
import 'screens/session_screen.dart';
import 'theme/app_theme.dart';

class TaskLabApp extends StatefulWidget {
  final AuthController auth;
  final TasksController tasks;
  const TaskLabApp({super.key, required this.auth, required this.tasks});
  @override
  State<TaskLabApp> createState() => _TaskLabAppState();
}

class _TaskLabAppState extends State<TaskLabApp> {
  final navigator = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    widget.auth.addListener(sessionChanged);
    widget.auth.restore();
  }

  void sessionChanged() {
    if (widget.auth.phase != AuthPhase.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.auth.phase != AuthPhase.authenticated) {
          navigator.currentState?.popUntil((route) => route.isFirst);
        }
      });
    }
  }

  @override
  void dispose() {
    widget.auth.removeListener(sessionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigator,
    title: 'TaskLab',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    builder: (context, child) => Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/vice_city_11_background.jpg', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x66070a11), Color(0x55070a11), Color(0x88070a11)],
            ),
          ),
        ),
        ?child,
      ],
    ),
    home: ListenableBuilder(
      listenable: widget.auth,
      builder: (_, _) => SessionScreen(auth: widget.auth, tasks: widget.tasks),
    ),
  );
}
