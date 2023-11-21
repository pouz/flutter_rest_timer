import 'dart:async';

import 'package:flutter/material.dart';

class PJClock extends StatefulWidget {
  const PJClock({
    super.key,
    this.is24Hour = false,
  });

  final bool is24Hour;

  @override
  State<PJClock> createState() => _PJClockState();
}

class _PJClockState extends State<PJClock> {
  late String _hour, _minute, _second;

  @override
  void initState() {
    _hour = DateTime.now().hour.toString();
    _minute = DateTime.now().minute.toString();
    _second = DateTime.now().second.toString();
    Timer.periodic(const Duration(seconds: 1), _getTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$_hour:$_minute:$_second'),
    );
  }

  void _getTime(Timer t) {
    setState(() {
      _hour = DateTime.now().hour.toString();
      _minute = DateTime.now().minute.toString();
      _second = DateTime.now().second.toString();
    });
  }
}
