import 'dart:math';

import 'package:desk_timer/utils/calculate.dart';
import 'package:flutter/material.dart';

class AnalogRestTimer extends StatelessWidget {
  const AnalogRestTimer({
    super.key,
    required this.paintSize,
    required this.totalTime,
    required this.percentage,
    required this.workingSec,
    required this.restSec,
  });

  final double totalTime;
  final double paintSize;
  final double percentage;
  final double workingSec;
  final double restSec;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: CustomPaint(
        size: Size(paintSize, paintSize),
        painter: AnalogRestTimerPainter(
          totalTime: totalTime,
          percentage: percentage,
          workingTime: workingSec,
          restTime: restSec,
        ),
      ),
    );
  }
}

// TODO: animated clock hand
class AnalogRestTimerPainter extends CustomPainter {
  AnalogRestTimerPainter({
    required this.totalTime,
    required this.workingTime,
    required this.restTime,
    required this.percentage,
  });

  final double totalTime;
  final double workingTime;
  final double restTime;
  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    _drawClockPercentage(canvas, size);
    _drawClockCover(canvas, size);
    _drawClockOutline(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawClockCover(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final handRadius = size.width / 2 + 8;

    var paintCover = Paint()..color = Colors.white;
    var paintHand = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // https://m.blog.naver.com/incoinco/221780288173
    // https://api.flutter.dev/flutter/dart-ui/Canvas/drawArc.html
    // percentage와theta와 다르기 때문에
    // pi / 180(2pi => 360 degrees 이기 때문에) 취한다
    var handX = centerX + handRadius * cos(_sweepAngle);
    var handY = centerY + handRadius * sin(_sweepAngle);

    var p = Path()
      ..moveTo(centerX, centerY)
      ..arcTo(
        Rect.fromCircle(
          radius: centerX,
          center: Offset(centerX, centerY),
        ),
        _startAngle,
        _sweepAngle,
        false,
      )
      ..close();

    canvas.drawPath(p, paintCover);
    canvas.drawCircle(Offset(handX, handY), 5, paintHand);
  }

  void _drawClockPercentage(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.pink;
    double sweepAngle = percentageToAngle(percentage);

    var p = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..arcTo(
        Rect.fromCircle(
          radius: size.height / 2,
          center: Offset(size.width / 2, size.height / 2),
        ),
        _startAngle,
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

  double percentageToAngle(double percentage) {
    return (percentage) * pi / 180;
  }

  double amountToAngle(double total, double amount) {
    if (amount == 0) return percentageToAngle(0);
    return percentageToAngle(amount / total * 360);
  }

  double get _getProgressTime => (totalTime - workingTime - restTime);
  double get _startAngle => percentageToAngle(0);
  double get _sweepAngle => amountToAngle(totalTime, _getProgressTime);
}
