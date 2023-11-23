import 'dart:async';

import 'package:desk_timer/feature/rest_timer.dart';
import 'package:desk_timer/screen/widget/analog_rest_timer.dart';
import 'package:desk_timer/screen/widget/display_timer.dart';
import 'package:desk_timer/screen/widget/modals/time_set_modal.dart';
import 'package:flutter/material.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({super.key});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> with TickerProviderStateMixin {
  // for texteditor
  late TextEditingController _workTextEditorController;
  late TextEditingController _restTextEditorController;
  final _rt = RestTimer();

  @override
  void initState() {
    _workTextEditorController =
        TextEditingController(text: (_rt.work ~/ 60).toString());
    _restTextEditorController =
        TextEditingController(text: (_rt.rest ~/ 60).toString());
    // for alarm
    // event on a sce
    _rt.addListener(() {
      setState(() {});
    });
    Timer.periodic(const Duration(seconds: 1), _rt.countSeconds);
    super.initState();
  }

  @override
  void dispose() {
    _rt.dispose();
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
                        totalTime: _rt.work + _rt.rest,
                        percentage: _rt.percentage,
                        workingSec: _rt.workingSec,
                        restSec: _rt.restSec,
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 18),
                          _rt.isWorking
                              ? DisplayTimer(
                                  totalSec: _rt.workingSec.toInt(),
                                  title: 'Work',
                                  backgroundColor: Colors.grey.shade100,
                                  textColor: Colors.pink.shade800,
                                )
                              : DisplayTimer(
                                  totalSec: _rt.restSec.toInt(),
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
          isClicked: _rt.isRunning,
          onPressed: () {
            _rt.startAndPause();
          },
        ),
        const SizedBox(width: 15),
        _button(
          backgroundColor: Colors.grey.shade800,
          iconColor: Colors.white,
          icon: Icons.replay,
          onPressed: () {
            _rt.reset();
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
                  onTapOK: (workMin, restMin) {
                    _rt.setting(workMin, restMin);
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
}
