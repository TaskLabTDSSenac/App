import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accent.withValues(alpha: .16),
              blurRadius: 30,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          Icons.directions_car_filled_rounded,
          color: AppTheme.ink,
          size: 42,
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'PITLANE',
        style: TextStyle(
          fontFamily: 'TaskLabText',
          fontSize: 29,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 2.7,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'SUA CENTRAL DE GARAGEM',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.accent,
          letterSpacing: 2,
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: child,
        ),
      ),
    ),
  );
}

class SectionEyebrow extends StatelessWidget {
  final String text;
  final IconData? icon;
  const SectionEyebrow(this.text, {super.key, this.icon});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (icon != null) ...[
        Icon(icon, size: 15, color: AppTheme.accent),
        const SizedBox(width: 7),
      ],
      Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.muted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.35,
        ),
      ),
    ],
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: success
                  ? const Color(0xffe2f0d7)
                  : const Color(0xffffe8e3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: success
                    ? const Color(0xffb6d6a8)
                    : const Color(0xffedc3ba),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  success ? Icons.check_circle_outline : Icons.info_outline,
                  size: 19,
                  color: success
                      ? const Color(0xff315b34)
                      : const Color(0xff9b3c32),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text!,
                    style: TextStyle(
                      color: success
                          ? const Color(0xff315b34)
                          : const Color(0xff852d28),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
      child: const CircularProgressIndicator(color: AppTheme.accent),
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
            const Icon(Icons.car_repair_rounded, size: 42, color: AppTheme.ink),
            const SizedBox(height: 12),
            MessageBox(message),
            FilledButton.icon(
              onPressed: retry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
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
