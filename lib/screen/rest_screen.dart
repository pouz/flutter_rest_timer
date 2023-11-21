import 'dart:async';

import 'package:desk_timer/screen/widget/display_timer.dart';
import 'package:desk_timer/widget/analog_rest_timer.dart';
import 'package:desk_timer/widget/turnable_button.dart';
import 'package:flutter/material.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({super.key});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

const double kWorkingSec = 45 * 60;
const double kRestSec = 15 * 60;

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
    //final paintSize = size.width / 2.3;
    var paintSize = 250.0;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AnalogRestTimer(
                      paintSize: paintSize,
                      totalTime: kWorkingSec + kRestSec,
                      percentage: _percentage,
                      workingSec: _workingSec,
                      restSec: _restSec,
                    ),
                    Column(
                      children: [
                        _workingSec == 0
                            ? DisplayTimer(
                                totalSec: _restSec.toInt(),
                                title: 'Rest',
                                backgroundColor: Colors.grey.shade200,
                                textColor: Colors.grey.shade800,
                              )
                            : DisplayTimer(
                                totalSec: _workingSec.toInt(),
                                title: 'Work',
                                backgroundColor: Colors.grey.shade100,
                                textColor: Colors.pink.shade800,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isRunning = true;
                                  _isWorking = true;
                                });
                              },
                              icon: const Icon(Icons.play_arrow),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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

  Widget _resetButton() {
    return TurnableButton(
      onPressed: () {
        setState(() {
          _isRunning = false;
          _isWorking = false;
          _workingSec = kWorkingSec;
          _restSec = kRestSec;
        });
      },
      enable: true,
      child: const Text('Start'),
    );
  }

  Widget _pauseButton() {
    return TurnableButton(
      onPressed: () {
        setState(() {
          _isRunning = false;
        });
      },
      enable: _isRunning,
      child: const Text('Pause'),
    );
  }

  Widget _startButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isRunning = true;
          _isWorking = true;
        });
      },
      icon: const Icon(Icons.play_arrow),
    );
  }
}
