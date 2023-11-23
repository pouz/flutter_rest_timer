import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class RestTimer with ChangeNotifier {
  int _work = 45 * 60;
  int _rest = 15 * 60;
  bool _isRunning = false;
  bool _isWorking = true;
  int _workingSec = 45 * 60;
  int _restSec = 15 * 60;

  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void countSeconds(Timer t) {
    if (!_isRunning) return;
    if (_workingSec <= 0 && _isWorking == true) {
      _isWorking = false;
      //_player.play(AssetSource('working_end.mp3'));
      _player.play(AssetSource('rest_end.mp3'));
    }

    if (_restSec <= 0 && _isWorking == false) {
      _isWorking = true;
      _player.play(AssetSource('rest_end.mp3'));
      _workingSec = _work;
      _restSec = _rest;
    }
    _isWorking ? _workingSec-- : _restSec--;
    notifyListeners();
  }

  void reset() {
    _isRunning = false;
    _workingSec = _work;
    _restSec = _rest;
    notifyListeners();
  }

  void startAndPause() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void setting(String workMin, String restMin) {
    if (workMin == '' || restMin == '') {
      workMin = '0';
      restMin = '0';
    }
    _work = int.parse(workMin) * 60;
    _rest = int.parse(restMin) * 60;
    reset();
  }

  bool get isRunning => _isRunning;
  bool get isWorking => _isWorking;
  int get workingSec => _workingSec;
  int get restSec => _restSec;
  int get work => _work;
  int get rest => _rest;
  double get percentage => (_work / (_work + _rest)) * 360;
}
