import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Semantics(
        label: 'TaskLab',
        child: Icon(Icons.two_wheeler, color: AppTheme.gold, size: 64),
      ),
      Text(
        'TASKLAB',
        style: TextStyle(
          fontFamily: 'TaskLabText',
          fontWeight: FontWeight.w700,
          fontSize: 34,
          color: AppTheme.gold,
        ),
      ),
      const Text(
        'MOTOR CLUB',
        style: TextStyle(
          color: AppTheme.gold,
          fontSize: 11,
          letterSpacing: 5,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      Text('SUA ROTA. SUAS REGRAS.', style: TextStyle(color: AppTheme.chrome)),
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
                  ? const Color(0xff203026)
                  : const Color(0xff35211f),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text!,
              style: TextStyle(
                color: success
                    ? const Color(0xffb5d9bc)
                    : const Color(0xffffb4a8),
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
