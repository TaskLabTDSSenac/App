import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Semantics(
        label: 'Dado de vinte lados',
        child: CustomPaint(
          size: const Size(46, 46),
          painter: D20Painter(),
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
      Text('Seu grimório de aventuras', style: TextStyle(color: AppTheme.paper)),
    ],
  );
}

class D20Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[
      Offset(size.width * 0.5, size.height * 0.04),
      Offset(size.width * 0.96, size.height * 0.31),
      Offset(size.width * 0.79, size.height * 0.88),
      Offset(size.width * 0.21, size.height * 0.88),
      Offset(size.width * 0.04, size.height * 0.31),
    ];
    final center = Offset(size.width * 0.5, size.height * 0.49);
    final outline = Paint()
      ..color = AppTheme.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = AppTheme.forest
      ..style = PaintingStyle.fill;

    final silhouette = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      silhouette.lineTo(point.dx, point.dy);
    }
    silhouette.close();
    canvas.drawPath(silhouette, fill);
    canvas.drawPath(silhouette, outline);

    for (var i = 0; i < points.length; i++) {
      final facet = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(points[i].dx, points[i].dy)
        ..lineTo(points[(i + 1) % points.length].dx, points[(i + 1) % points.length].dy);
      canvas.drawPath(facet, outline..strokeWidth = 1.15);
    }

    final number = TextPainter(
      text: const TextSpan(
        text: '20',
        style: TextStyle(
          color: AppTheme.brightGold,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    number.paint(canvas, Offset(center.dx - number.width / 2, center.dy - number.height / 2));
  }

  @override
  bool shouldRepaint(covariant D20Painter oldDelegate) => false;
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
      label: 'Preparando sua aventura',
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
