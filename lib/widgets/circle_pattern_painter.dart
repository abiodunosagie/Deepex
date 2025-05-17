import 'dart:math';

import 'package:flutter/material.dart';

class CurvedLinePatternPainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;
  final int lineCount;
  final double amplitude;

  CurvedLinePatternPainter({
    this.lineColor = const Color(0x33FFFFFF),
    this.strokeWidth = 1.5,
    this.lineCount = 4,
    this.amplitude = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = lineColor;

    final rand = Random();

    // draw `lineCount` horizontal waves
    for (int i = 0; i < lineCount; i++) {
      final yBase = size.height * (i + 1) / (lineCount + 1);
      final path = Path()..moveTo(0, yBase);

      // break the width into segments, draw quad beziers
      final segWidth = size.width / 4;
      for (double x = 0; x <= size.width; x += segWidth) {
        final nextX = x + segWidth;
        final nextY = yBase;
        // random control point offsets
        final cpX = x + segWidth / 2 + rand.nextDouble() * 40 - 20;
        final cpY = yBase + rand.nextDouble() * amplitude * 2 - amplitude;
        path.quadraticBezierTo(cpX, cpY, nextX, nextY);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
