import 'dart:math';
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

  final int totalTime;
  final double paintSize;
  final double percentage;
  final int workingSec;
  final int restSec;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(paintSize),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: RotatedBox(
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
      ),
    );
  }
}

// TODO: animated clock hand
// TODO: make timer handler
// https://github.com/navinkumar0118/NavTimer
// https://navinkumar0118.medium.com/flutter-countdown-timer-works-in-background-f87488b0ba4c
class AnalogRestTimerPainter extends CustomPainter {
  AnalogRestTimerPainter({
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawClockCover(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final handRadius = size.width / 2 + 8;

    var paintCover = Paint()..color = Colors.white.withOpacity(0.3);
    var paintHand = Paint()
      ..color = Colors.grey.shade800
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
    var center = Offset(size.width / 2, size.height / 2);
    var outRadius = size.height / 2;
    var paint = Paint()..color = Colors.pink;
    var paintGrey = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey
      ..isAntiAlias = true;
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

    // draw outline on circle
    canvas.drawCircle(
      center,
      outRadius,
      paintGrey,
    );
    // draw percentage
    canvas.drawPath(p, paint);
  }

  void _drawClockOutline(Canvas canvas, Size size) {
    var innerRadius = size.height / 2.3;
    var center = Offset(size.width / 2, size.height / 2);

    var innerEmptyPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..isAntiAlias = true;

    // fill inner space on circle
    canvas.drawCircle(
      center,
      innerRadius,
      innerEmptyPaint,
    );
  }

  double percentageToAngle(double percentage) {
    return (percentage) * pi / 180;
  }

  double amountToAngle(int total, int amount) {
    if (amount == 0) return percentageToAngle(0);
    return percentageToAngle(amount / total * 360);
  }

  int get _getProgressTime => (totalTime - workingTime - restTime);
  double get _startAngle => percentageToAngle(0);
  double get _sweepAngle => amountToAngle(totalTime, _getProgressTime);
}
