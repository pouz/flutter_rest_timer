import 'dart:math';

import 'package:flutter/material.dart';

class PacManPainter extends CustomPainter {
  final Animation listenable;

  PacManPainter({
    required this.listenable,
  }) : super(repaint: listenable);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.yellow;
    double sweepAngle = (360.0 - listenable.value) * pi / 180;
    double startAngle = (listenable.value / 2) * pi / 180;

    var p = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..arcTo(
        Rect.fromCircle(
            radius: size.height / 2,
            center: Offset(
              size.width / 2,
              size.height / 2,
            )),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
