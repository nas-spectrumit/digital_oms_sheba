import 'package:flutter/material.dart';

class IDCardOverlay extends StatelessWidget {
  const IDCardOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: IDCardOverlayPainter(),
        child: Container(),
      ),
    );
  }
}

class IDCardOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    const cardAspectRatio = 1.3; // ID camera_and_images ratio
    final cardWidth = size.width * 0.83;
    final cardHeight = cardWidth / cardAspectRatio;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(center: center, width: cardWidth, height: cardHeight);

    final bgPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectXY(rect, 16, 16));
    final finalPath = Path.combine(PathOperation.difference, bgPath, cutoutPath);

    canvas.drawPath(finalPath, paint);

    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(RRect.fromRectXY(rect, 16, 16), borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
