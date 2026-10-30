import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Semantics(
        label: 'TaskLab - performance',
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xff20252a),
            border: Border.all(color: AppTheme.gold, width: 2),
          ),
          child: const Icon(Icons.speed_rounded, color: AppTheme.gold, size: 42),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'TASKLAB',
        style: TextStyle(
          fontFamily: 'TaskLabText', fontSize: 30, fontWeight: FontWeight.w700,
          letterSpacing: 3, color: Colors.white,
        ),
      ),
      const Text(
        'DESEMPENHO EM CADA TAREFA',
        style: TextStyle(color: Color(0xffadb5bd), letterSpacing: 1.2, fontSize: 11),
      ),
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
              color: success ? const Color(0xff1e392e) : const Color(0xff492220),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text!,
              style: TextStyle(color: success ? const Color(0xff9de0bd) : const Color(0xffffaaa5)),
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
            FilledButton(onPressed: retry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    ),
  );
}

void showNotice(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
