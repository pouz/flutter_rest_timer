import 'dart:async';

import 'package:desk_timer/feature/rest_timer.dart';
import 'package:desk_timer/screen/widget/analog_rest_timer.dart';
import 'package:desk_timer/screen/widget/display_timer.dart';
import 'package:desk_timer/screen/widget/modals/time_set_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestScreen extends ConsumerStatefulWidget {
  const RestScreen({super.key});

  @override
  ConsumerState<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends ConsumerState<RestScreen>
    with TickerProviderStateMixin {
  // for texteditor
  late TextEditingController _workTextEditorController;
  late TextEditingController _restTextEditorController;

  @override
  void initState() {
    final rt = ref.read(restTimerProvider);
    _workTextEditorController =
        TextEditingController(text: (rt.work ~/ 60).toString());
    _restTextEditorController =
        TextEditingController(text: (rt.rest ~/ 60).toString());
    // event on a sce
    Timer.periodic(
      const Duration(seconds: 1),
      ref.read(restTimerProvider.notifier).countSeconds,
    );
    super.initState();
  }

  @override
  void dispose() {
    ref.read(restTimerProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rt = ref.watch(restTimerProvider);
    final rtn = ref.read(restTimerProvider.notifier);
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
                        totalTime: rtn.work + rtn.rest,
                        percentage: rtn.percentage,
                        workingSec: rt.work,
                        restSec: rt.rest,
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 18),
                          rtn.isWorking
                              ? DisplayTimer(
                                  totalSec: rt.work.toInt(),
                                  title: 'Work',
                                  backgroundColor: Colors.grey.shade100,
                                  textColor: Colors.pink.shade800,
                                )
                              : DisplayTimer(
                                  totalSec: rt.rest.toInt(),
                                  title: 'Rest',
                                  backgroundColor: Colors.grey.shade200,
                                  textColor: Colors.grey.shade800,
                                ),
                          const SizedBox(height: 10),
                          _buttons(rt, rtn),
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

  Row _buttons(WorkRest rt, RestTimer rtn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _button(
          backgroundColor: Colors.grey.shade800,
          iconColor: Colors.white,
          clickedIconColor: Colors.white,
          icon: Icons.play_arrow,
          clickedIcon: Icons.pause,
          isClicked: rtn.isRunning,
          onPressed: () {
            rtn.startAndPause();
          },
        ),
        const SizedBox(width: 15),
        _button(
          backgroundColor: Colors.grey.shade800,
          iconColor: Colors.white,
          icon: Icons.replay,
          onPressed: () {
            rtn.reset();
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
                    rtn.setting(workMin, restMin);
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
