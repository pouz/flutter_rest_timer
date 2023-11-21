import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  ClockPainter({
    required this.totalTime,
    required this.workingTime,
    required this.restTime,
    required this.percentage,
  });

  final int totalTime;
  final int workingTime;
  final int restTime;
  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    _drawClockPercentage(canvas, size);
    _drawClockCover(canvas, size);
    _drawClockOutline(canvas, size);
    _drawClockHand(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawClockHand(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 + 8;

    var progressTime = totalTime - workingTime - restTime;
    // https://m.blog.naver.com/incoinco/221780288173
    // percentage와theta와 다르기 때문에
    // pi / 180(2pi => 360 degrees 이기 때문에) 취한다
    double angle = progressTime == 0
        ? -90 * pi / 180
        : (progressTime / totalTime * 360 - 90) * pi / 180;

    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    var x = centerX + radius * cos(angle);
    var y = centerY + radius * sin(angle);

    canvas.drawCircle(Offset(x, y), 5, paint);
  }

  void _drawClockCover(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;
    var progressTime = totalTime - workingTime - restTime;
    double startAngle = -90 * pi / 180;
    double sweepAngle =
        progressTime == 0 ? 0 : progressTime / totalTime * 360 * pi / 180;

    var p = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..arcTo(
        Rect.fromCircle(
          radius: size.height / 2,
          center: Offset(size.width / 2, size.height / 2),
        ),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();

    canvas.drawPath(p, paint);
  }

  void _drawClockPercentage(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.pink;
    // https://api.flutter.dev/flutter/dart-ui/Canvas/drawArc.html
    double startAngle = 270 * pi / 180;
    double sweepAngle = percentage * pi / 180;

    var p = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..arcTo(
        Rect.fromCircle(
          radius: size.height / 2,
          center: Offset(size.width / 2, size.height / 2),
        ),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();

    canvas.drawPath(p, paint);
  }

  void _drawClockOutline(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black
      ..isAntiAlias = true;

    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      size.height / 2,
      paint,
    );
  }
}
