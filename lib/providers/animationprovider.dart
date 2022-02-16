import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/sleepinput.dart';

class AnimationProvider with ChangeNotifier {
  int _length = 0;

  final List<double> _opacity = [];

  List<double> get getOpacity => _opacity;

  int _i = 0;

  int get getIntI => _i;

  int get getListLength => _length;

  double _height = 0;

  double get getHeight => _height;

  bool _back = false;

  bool get wentBack => _back;

  // Future<void> init() async {
  //   _length = await Hive.openBox('sleepData').then((value) => value.length);
  //   setOpacityListLength(_length);
  // }

  void displayOne(int i) {
    for (int k = 0; k < _length; k++) {
      k == i ? _opacity[k] = 1.0 : _opacity[k] = 0.0;
    }
    notifyListeners();
  }

  void setOpacityListLength(int listLength) {
    for (int i = 0; i < listLength; i++) {
      _opacity.add(1.0);
    }
    _length = _opacity.length;
    //notifyListeners();
  }

  void displayAll() {
    for (int i = 0; i < _opacity.length; i++) {
      _opacity[i] = 1.0;
    }
  }

  void setHeight(bool display) {
    display ? _height = 75 : _height = 0;
    notifyListeners();
  }
  // void setI(int i) {
  //   _i = i;
  //   notifyListeners();
  // }

  void backPressed(bool pressed) {
    _back = true;
    notifyListeners();
  }
}
