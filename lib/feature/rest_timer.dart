import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkRest {
  WorkRest({
    required this.work,
    required this.rest,
  });

  late int work;
  late int rest;

  WorkRest copywith({
    int? work,
    int? rest,
  }) {
    return WorkRest(
      work: work ?? this.work,
      rest: rest ?? this.rest,
    );
  }
}

class RestTimer extends Notifier<WorkRest> {
  RestTimer({
    required int work,
    required int rest,
  }) {
    _totalWork = work;
    _totalRest = rest;
  }

  late int _totalWork;
  late int _totalRest;
  bool _isRunning = false;
  bool _isWorking = true;

  final AudioPlayer _player = AudioPlayer();

  @override
  WorkRest build() {
    return WorkRest(work: _totalWork, rest: _totalRest);
  }

  void dispose() {
    _player.dispose();
  }

  void countSeconds(Timer t) {
    if (!_isRunning) return;
    if (state.work <= 0 && _isWorking == true) {
      _isWorking = false;
      //_player.play(AssetSource('working_end.mp3'));
      _player.play(AssetSource('rest_end.mp3'));
    }

    if (state.rest <= 0 && _isWorking == false) {
      _isWorking = true;
      _player.play(AssetSource('rest_end.mp3'));
      state = WorkRest(work: _totalWork, rest: _totalRest);
    }
    _isWorking
        ? state = state.copywith(work: --state.work)
        : state = state.copywith(rest: --state.rest);
  }

  void reset() {
    _isRunning = false;
    state = WorkRest(work: _totalWork, rest: _totalRest);
  }

  void startAndPause() {
    _isRunning = !_isRunning;
    state = state.copywith();
  }

  void setting(String workMin, String restMin) {
    if (workMin == '' || restMin == '') {
      workMin = '0';
      restMin = '0';
    }
    _totalWork = int.parse(workMin) * 60;
    _totalRest = int.parse(restMin) * 60;
    reset();
  }

  bool get isRunning => _isRunning;
  bool get isWorking => _isWorking;
  int get work => _totalWork;
  int get rest => _totalRest;
  double get percentage => (_totalWork / (_totalWork + _totalRest)) * 360;
}

final restTimerProvider = NotifierProvider<RestTimer, WorkRest>(() {
  return RestTimer(work: 45 * 60, rest: 15 * 60);
});
