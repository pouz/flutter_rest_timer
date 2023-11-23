import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:desk_timer/screen/widget/analog_rest_timer.dart';
import 'package:desk_timer/screen/widget/display_timer.dart';
import 'package:desk_timer/screen/widget/modals/time_set_modal.dart';
import 'package:flutter/material.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({super.key});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

int work = 45 * 60;
int rest = 15 * 60;

class _RestScreenState extends State<RestScreen> with TickerProviderStateMixin {
  bool _isRunning = false;
  bool _isWorking = true;
  int _workingSec = work;
  int _restSec = rest;
  // for texteditor
  late TextEditingController _workTextEditorController;
  late TextEditingController _restTextEditorController;

  // for alarm
  late final AudioPlayer _player;

  @override
  void initState() {
    _workTextEditorController = TextEditingController(text: '45');
    _restTextEditorController = TextEditingController(text: '15');
    // for alarm
    _player = AudioPlayer();
    // event on a sce
    Timer.periodic(const Duration(seconds: 1), _countSeconds);
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var paintSize = 250.0;
    return Scaffold(
      body: Container(
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
                        totalTime: work + rest,
                        percentage: _percentage,
                        workingSec: _workingSec,
                        restSec: _restSec,
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 18),
                          _isWorking
                              ? DisplayTimer(
                                  totalSec: _workingSec.toInt(),
                                  title: 'Work',
                                  backgroundColor: Colors.grey.shade100,
                                  textColor: Colors.pink.shade800,
                                )
                              : DisplayTimer(
                                  totalSec: _restSec.toInt(),
                                  title: 'Rest',
                                  backgroundColor: Colors.grey.shade200,
                                  textColor: Colors.grey.shade800,
                                ),
                          const SizedBox(height: 10),
                          _buttons(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _button(
          backgroundColor: Colors.grey.shade800,
          iconColor: Colors.white,
          clickedIconColor: Colors.white,
          icon: Icons.play_arrow,
          clickedIcon: Icons.pause,
          isClicked: _isRunning,
          onPressed: () {
            setState(() {
              _isRunning = !_isRunning;
            });
          },
        ),
        const SizedBox(width: 15),
        _button(
          backgroundColor: Colors.grey.shade800,
          iconColor: Colors.white,
          icon: Icons.replay,
          onPressed: () {
            setState(() {
              _isRunning = false;
              _workingSec = work;
              _restSec = rest;
            });
          },
        ),
        const SizedBox(width: 15),
        _button(
          backgroundColor: Colors.grey.shade800,
          iconColor: Colors.white,
          icon: Icons.settings,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return TimeSetModal(
                  workController: _workTextEditorController,
                  restController: _restTextEditorController,
                  onChangedWorkTime: (value) {
                    setState(() {
                      work = int.parse(value) * 60;
                      _workingSec = work;
                    });
                  },
                  onChangedRestTime: (value) {
                    setState(() {
                      rest = int.parse(value) * 60;
                      _restSec = rest;
                    });
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _button({
    Color? backgroundColor,
    Color? iconColor,
    Color? clickedIconColor,
    void Function()? onPressed,
    IconData? icon,
    IconData? clickedIcon,
    bool isClicked = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: isClicked
            ? Icon(
                clickedIcon,
                color: clickedIconColor,
              )
            : Icon(
                icon,
                color: iconColor,
              ),
      ),
    );
  }

  void _countSeconds(Timer t) {
    setState(() {
      if (!_isRunning) return;
      if (_workingSec <= 0 && _isWorking == true) {
        _isWorking = false;
        _player.play(AssetSource('working_end.mp3'));
      }

      if (_restSec <= 0 && _isWorking == false) {
        _isWorking = true;
        _player.play(AssetSource('rest_end.mp3'));
        _workingSec = work;
        _restSec = rest;
      }
      _isWorking ? _workingSec-- : _restSec--;
    });
  }

  double get _percentage => (work / (work + rest)) * 360;
}
