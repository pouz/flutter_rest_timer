import 'dart:async';

import 'package:desk_timer/widget/analog_rest_timer.dart';
import 'package:desk_timer/widget/turnable_button.dart';
import 'package:flutter/material.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({super.key});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

const double kWorkingSec = 20;
const double kRestSec = 10;

class _RestScreenState extends State<RestScreen> with TickerProviderStateMixin {
  bool _isRunning = false;
  bool _isWorking = false;
  double _workingSec = kWorkingSec;
  double _restSec = kRestSec;
  final double _percentage = (kWorkingSec / (kWorkingSec + kRestSec)) * 360;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), _countSeconds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paintSize = size.width / 2;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned.fill(
            child: Center(
              child: AnalogRestTimer(
                paintSize: paintSize,
                totalTime: kWorkingSec + kRestSec,
                percentage: _percentage,
                workingSec: _workingSec,
                restSec: _restSec,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Text('w: $_workingSec, r: $_restSec'),
          ),
          Positioned(
            bottom: size.height / 100 * 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _startButton(),
                const SizedBox(width: 300),
                _stopButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _countSeconds(Timer t) {
    setState(() {
      if (!_isRunning) return;
      _isWorking ? _workingSec-- : _restSec--;
      if (_workingSec <= 0) {
        _isWorking = false;
        // TODO: do alarm for end of working time
      }

      if (_restSec <= 0) {
        _isWorking = true;
        // TODO: do alarm for end of rest time
        // TODO: reset working and rest time
        _workingSec = 20;
        _restSec = 10;
      }
    });
  }

  Widget _stopButton() {
    return TurnableButton(
      onPressed: () {
        setState(() {
          _isRunning = false;
        });
      },
      style: _restButtonStyle,
      enable: _isRunning,
      child: const Text('Stop'),
    );
  }

  Widget _startButton() {
    return TurnableButton(
      onPressed: () {
        setState(() {
          _isRunning = true;
          _isWorking = true;
        });
      },
      style: _restButtonStyle,
      enable: !_isRunning,
      child: const Text('Start'),
    );
  }
}

ButtonStyle _restButtonStyle = ElevatedButton.styleFrom(
  elevation: 0,
  shadowColor: Colors.white,
  backgroundColor: Colors.black,
);
