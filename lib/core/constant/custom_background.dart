import 'package:flutter/material.dart';

/// A reusable, visually rich background for auth/login screens.
/// Uses only Flutter primitives — no external packages needed.
///
/// Usage:
/// ```dart
/// Scaffold(
///   body: LoginBackground(
///     child: YourContent(),
///   ),
/// )
/// ```
class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // ── Base gradient ────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade50, Colors.white, primary.withValues(alpha: 0.04)],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        ),

        // ── Top-left large arc bubble ────────────────────────────────
        Positioned(
          top: -size.height * 0.12,
          left: -size.width * 0.18,
          child: _GlowCircle(diameter: size.width * 0.75, color: primary.withValues(alpha: 0.08), blurRadius: 60),
        ),

        // ── Top-right small accent circle ───────────────────────────
        Positioned(
          top: size.height * 0.04,
          right: -size.width * 0.08,
          child: _GlowCircle(diameter: size.width * 0.38, color: primary.withValues(alpha: 0.12), blurRadius: 40),
        ),

        // ── Decorative ring — top right ──────────────────────────────
        Positioned(
          top: size.height * 0.06,
          right: -size.width * 0.14,
          child: _Ring(diameter: size.width * 0.52, strokeWidth: 1.2, color: primary.withValues(alpha: 0.18)),
        ),

        // ── Decorative ring — top right (inner) ─────────────────────
        Positioned(
          top: size.height * 0.10,
          right: -size.width * 0.06,
          child: _Ring(diameter: size.width * 0.30, strokeWidth: 0.8, color: primary.withValues(alpha: 0.10)),
        ),

        // ── Bottom-right large glow ──────────────────────────────────
        Positioned(
          bottom: -size.height * 0.10,
          right: -size.width * 0.20,
          child: _GlowCircle(diameter: size.width * 0.80, color: primary.withValues(alpha: 0.07), blurRadius: 70),
        ),

        // ── Bottom-left accent blob ──────────────────────────────────
        Positioned(
          bottom: size.height * 0.08,
          left: -size.width * 0.10,
          child: _GlowCircle(diameter: size.width * 0.45, color: primary.withValues(alpha: 0.06), blurRadius: 50),
        ),

        // ── Bottom-left ring ─────────────────────────────────────────
        Positioned(
          bottom: size.height * 0.05,
          left: -size.width * 0.16,
          child: _Ring(diameter: size.width * 0.55, strokeWidth: 1.0, color: primary.withValues(alpha: 0.12)),
        ),

        // ── Scattered dot grid (top half) ───────────────────────────
        Positioned(
          top: size.height * 0.12,
          left: size.width * 0.05,
          child: _DotGrid(rows: 5, cols: 4, spacing: 18, dotRadius: 1.4, color: primary.withValues(alpha: 0.15)),
        ),

        // ── Scattered dot grid (bottom half) ────────────────────────
        Positioned(
          bottom: size.height * 0.14,
          right: size.width * 0.06,
          child: _DotGrid(rows: 4, cols: 4, spacing: 18, dotRadius: 1.4, color: primary.withValues(alpha: 0.13)),
        ),

        // ── Diagonal thin lines (top area) ──────────────────────────
        Positioned(
          top: 0,
          right: 0,
          child: _DiagonalLines(
            width: size.width * 0.5,
            height: size.height * 0.32,
            color: primary.withValues(alpha: 0.05),
            lineSpacing: 22,
          ),
        ),

        // ── Content on top ──────────────────────────────────────────
        child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Soft glowing filled circle.
class _GlowCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  final double blurRadius;

  const _GlowCircle({required this.diameter, required this.color, required this.blurRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: blurRadius, spreadRadius: blurRadius * 0.3)],
      ),
    );
  }
}

/// Outlined circle ring.
class _Ring extends StatelessWidget {
  final double diameter;
  final double strokeWidth;
  final Color color;

  const _Ring({required this.diameter, required this.strokeWidth, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(diameter, diameter),
      painter: _RingPainter(strokeWidth: strokeWidth, color: color),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  _RingPainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.color != color || old.strokeWidth != strokeWidth;
}

/// Grid of evenly spaced tiny dots.
class _DotGrid extends StatelessWidget {
  final int rows;
  final int cols;
  final double spacing;
  final double dotRadius;
  final Color color;

  const _DotGrid({
    required this.rows,
    required this.cols,
    required this.spacing,
    required this.dotRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(cols * spacing, rows * spacing),
      painter: _DotGridPainter(rows: rows, cols: cols, spacing: spacing, dotRadius: dotRadius, color: color),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final int rows, cols;
  final double spacing, dotRadius;
  final Color color;

  _DotGridPainter({
    required this.rows,
    required this.cols,
    required this.spacing,
    required this.dotRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(Offset(c * spacing, r * spacing), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => false;
}

/// Diagonal parallel lines filling a rectangle.
class _DiagonalLines extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double lineSpacing;

  const _DiagonalLines({required this.width, required this.height, required this.color, required this.lineSpacing});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _DiagonalLinesPainter(color: color, lineSpacing: lineSpacing),
    );
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;
  final double lineSpacing;

  _DiagonalLinesPainter({required this.color, required this.lineSpacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw lines at 45° across the bounding box
    final total = (size.width + size.height) / lineSpacing;
    for (int i = 0; i <= total.ceil(); i++) {
      final offset = i * lineSpacing;
      canvas.drawLine(Offset(offset, 0), Offset(0, offset), paint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalLinesPainter old) => false;
}
