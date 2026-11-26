import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/tasks_controller.dart';
import 'screens/session_screen.dart';
import 'theme/app_theme.dart';
import 'theme/font_preference.dart';

class TaskLabApp extends StatefulWidget {
  final AuthController auth;
  final TasksController tasks;
  const TaskLabApp({super.key, required this.auth, required this.tasks});
  @override
  State<TaskLabApp> createState() => _TaskLabAppState();
}

class _TaskLabAppState extends State<TaskLabApp> {
  final navigator = GlobalKey<NavigatorState>();
  late final FontPreference fontPreference;

  @override
  void initState() {
    super.initState();
    fontPreference = FontPreference();
    unawaited(fontPreference.load());
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
    fontPreference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: fontPreference,
    builder: (context, _) => MaterialApp(
      navigatorKey: navigator,
      title: 'Crônicas do Grimório',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(fontStyle: fontPreference.style),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ListenableBuilder(
        listenable: widget.auth,
        builder: (_, _) => SessionScreen(
          auth: widget.auth,
          tasks: widget.tasks,
          fontPreference: fontPreference,
        ),
      ),
    ),
  );
}
