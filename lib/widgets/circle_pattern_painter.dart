import 'dart:math';

import 'package:flutter/material.dart';

/// Optimized circuit pattern painter for wallet card background
class CircuitPatternPainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;
  final int lineCount;
  final int nodeCount;

  /// Creates a circuit pattern with customizable properties
  const CircuitPatternPainter({
    this.lineColor = const Color(0x33FFFFFF),
    this.strokeWidth = 1.2,
    this.lineCount = 12,
    this.nodeCount = 15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent pattern

    // Optimized paints - reuse for better performance
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = lineColor;

    final nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = lineColor.withAlpha((lineColor.alpha * 0.6).round());

    // Draw horizontal and vertical circuit lines
    _drawCircuitLines(canvas, size, linePaint, random);

    // Draw circuit nodes (connection points)
    _drawCircuitNodes(canvas, size, nodePaint, random);
  }

  void _drawCircuitLines(Canvas canvas, Size size, Paint paint, Random random) {
    final horizontalCount = (lineCount / 2).ceil();
    final verticalCount = lineCount - horizontalCount;

    // Draw horizontal circuit paths
    for (int i = 0; i < horizontalCount; i++) {
      final path = Path();
      double y = size.height * (0.1 + (0.8 / horizontalCount) * i);

      // Randomize start position
      double x = random.nextDouble() * size.width * 0.3;
      path.moveTo(x, y);

      // Determine path length
      double endX = x + size.width * (0.3 + random.nextDouble() * 0.7);
      if (endX > size.width) endX = size.width;

      // Add some segments with right-angle turns
      int segments = 1 + random.nextInt(3);
      double segLength = (endX - x) / segments;

      for (int j = 0; j < segments; j++) {
        double nextX = x + segLength;

        // Occasionally add a vertical segment
        if (random.nextDouble() > 0.7) {
          double offsetY = random.nextBool()
              ? random.nextDouble() * 20
              : -random.nextDouble() * 20;
          // Make sure we don't go off the card
          if (y + offsetY < 0) offsetY = -y + 2;
          if (y + offsetY > size.height) offsetY = size.height - y - 2;

          path.lineTo(nextX, y);
          path.lineTo(nextX, y + offsetY);
          y += offsetY;
        }

        path.lineTo(nextX, y);
        x = nextX;
      }

      canvas.drawPath(path, paint);
    }

    // Draw vertical circuit paths
    for (int i = 0; i < verticalCount; i++) {
      final path = Path();
      double x = size.width * (0.15 + (0.7 / verticalCount) * i);

      // Randomize start position
      double y = random.nextDouble() * size.height * 0.4;
      path.moveTo(x, y);

      // Determine path length
      double endY = y + size.height * (0.3 + random.nextDouble() * 0.7);
      if (endY > size.height) endY = size.height;

      // Add some segments with right-angle turns
      int segments = 1 + random.nextInt(2);
      double segLength = (endY - y) / segments;

      for (int j = 0; j < segments; j++) {
        double nextY = y + segLength;

        // Occasionally add a horizontal segment
        if (random.nextDouble() > 0.7) {
          double offsetX = random.nextBool()
              ? random.nextDouble() * 20
              : -random.nextDouble() * 20;
          // Make sure we don't go off the card
          if (x + offsetX < 0) offsetX = -x + 2;
          if (x + offsetX > size.width) offsetX = size.width - x - 2;

          path.lineTo(x, nextY);
          path.lineTo(x + offsetX, nextY);
          x += offsetX;
        }

        path.lineTo(x, nextY);
        y = nextY;
      }

      canvas.drawPath(path, paint);
    }
  }

  void _drawCircuitNodes(Canvas canvas, Size size, Paint paint, Random random) {
    for (int i = 0; i < nodeCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      // Vary circle sizes for more interesting pattern
      final radius = 0.8 + random.nextDouble() * 2.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CircuitPatternPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.lineCount != lineCount ||
      oldDelegate.nodeCount != nodeCount;
}
