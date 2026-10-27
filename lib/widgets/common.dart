import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Semantics(
        label: 'TaskLab',
        child: Icon(
          Icons.auto_stories_outlined,
          color: AppTheme.gold,
          size: 46,
        ),
      ),
      Text(
        'TaskLab',
        style: TextStyle(
          fontFamily: 'TaskLabTitle',
          fontSize: 34,
          color: AppTheme.gold,
        ),
      ),
      Text('Seu grimório de tarefas', style: TextStyle(color: AppTheme.paper)),
    ],
  );
}

class PageBody extends StatelessWidget {
  final Widget child;
  const PageBody({super.key, required this.child});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: child,
        ),
      ),
    ),
  );
}

class MessageBox extends StatelessWidget {
  final String? text;
  final bool success;
  const MessageBox(this.text, {super.key, this.success = false});
  @override
  Widget build(BuildContext context) => text == null
      ? const SizedBox.shrink()
      : Semantics(
          liveRegion: true,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: success
                  ? const Color(0xffe2e9d4)
                  : const Color(0xfffae8df),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text!,
              style: TextStyle(
                color: success
                    ? const Color(0xff315333)
                    : const Color(0xff852d28),
              ),
            ),
          ),
        );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      label: 'Carregando',
      child: CircularProgressIndicator(color: AppTheme.gold),
    ),
  );
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback retry;
  const ErrorView({super.key, required this.message, required this.retry});
  @override
  Widget build(BuildContext context) => PageBody(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MessageBox(message),
            FilledButton(
              onPressed: retry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    ),
  );
}

void showNotice(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
