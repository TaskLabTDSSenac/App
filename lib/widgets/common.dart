import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Column(children: [
    Container(width: 72, height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xfff2768b), Color(0xffffc857)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: AppTheme.pink.withValues(alpha: .22), blurRadius: 26, spreadRadius: 2)],
      ),
      child: const Icon(Icons.bolt_rounded, color: AppTheme.night, size: 42),
    ),
    const SizedBox(height: 12),
    const Text('TASKLAB', style: TextStyle(fontFamily: 'TaskLabTitle', fontSize: 32, color: AppTheme.paper, letterSpacing: 3)),
    const SizedBox(height: 3),
    const Text('SUA CIDADE. SEU RITMO. SUAS MISSÕES.', style: TextStyle(color: AppTheme.cyan, fontSize: 10, letterSpacing: 1.3, fontWeight: FontWeight.w800)),
  ]);
}

class PageBody extends StatelessWidget {
  final Widget child;
  const PageBody({super.key, required this.child});
  @override
  Widget build(BuildContext context) => SafeArea(child: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: child)),
  ));
}
class MessageBox extends StatelessWidget {
  final String? text;
  final bool success;
  const MessageBox(this.text, {super.key, this.success = false});
  @override
  Widget build(BuildContext context) => text == null ? const SizedBox.shrink() : Semantics(
    liveRegion: true,
    child: Container(width: double.infinity, margin: const EdgeInsets.symmetric(vertical: 12), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: success ? const Color(0xff1c3c35) : const Color(0xff472d35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: success ? AppTheme.cyan.withValues(alpha: .35) : AppTheme.pink.withValues(alpha: .35)),
      ),
      child: Text(text!, style: TextStyle(color: success ? AppTheme.cyan : const Color(0xffffb4bd))),
    ),
  );
}
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Semantics(label: 'Carregando', child: CircularProgressIndicator(color: AppTheme.gold)));
}
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback retry;
  const ErrorView({super.key, required this.message, required this.retry});
  @override
  Widget build(BuildContext context) => PageBody(child: Card(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      MessageBox(message), FilledButton(onPressed: retry, child: const Text('Tentar novamente')),
    ]),
  )));
}
void showNotice(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

