import 'package:flutter/material.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/functions/sleepdatachart.dart';
import 'package:zzzleep/models/sleepinput.dart';

class SleepDataProvider with ChangeNotifier {
  List<SleepData> _sleepDataList = [];

  List<SleepData> get getSleepDataList => _sleepDataList;

  // bool _prikaziNulu = false;

  // bool get getPrikaziNulu => _prikaziNulu;

  final TextEditingController _notesController = TextEditingController();

  TextEditingController get getNotesController => _notesController;

  bool _secondScreen = false;

  bool get getSecondScreen => _secondScreen;

  List<SleepData> _initialSleepData = [];

  List<SleepData> get getInitialSleepData => _initialSleepData;

  List wholeList = [];

  int _i = 0;

  int get getIndex => _i;

  bool _hasFocus = false;

  bool get getFocus => _hasFocus;

  List<SleepChartData> _chartData = [];

  List<SleepChartData> get getChartData => _chartData;

  final List<Color>? _color = [];

  List<Color>? get getColor => _color;

  bool _chooseTimePressed = false;

  bool get getChooseTimeButton => _chooseTimePressed;

  set setInitialSleepData(List<SleepData> sleepData) {
    _initialSleepData = sleepData;
  }

  set setWholeList(List<SleepData>? sleepData) {
    wholeList.add(sleepData);
  }

  List get getWholeList => wholeList;

  void setSleepDataList({@required List<SleepData>? sleepData}) {
    _sleepDataList = sleepData!;
    for (int i = 0; i < sleepData.length; i++) {
      _color!.add(Colors.white);
    }
    notifyListeners();
  }

  void increaseSleepDataList({@required SleepData? sleepData}) {
    _sleepDataList.add(sleepData!);
    _color!.add(Colors.white);
    notifyListeners();
  }

  void setFallenAsleep({@required int? i, @required String? fallenAsleep}) {
    _sleepDataList[i!].fallenAsleep = fallenAsleep!;
    notifyListeners();
  }

  void setWokenUp({@required int? i, @required String? wokenUp}) {
    _sleepDataList[i!].wokenUp = wokenUp!;
    notifyListeners();
  }

  void calculateHoursMinutes(
      {@required int? i, @required int? hours, @required int? minutes}) {
    _sleepDataList[i!].hours = hours!;
    _sleepDataList[i].minutes = minutes!;
    notifyListeners();
  }

  void setNotes({@required String? notes}) {
    _sleepDataList[0].notes = notes!;
    _notesController.value = _notesController.value.copyWith(text: notes);
    notifyListeners();
  }

  void secondScreen(bool secondScreen) {
    _secondScreen = secondScreen;
    notifyListeners();
  }

  void itemIndex(int i) {
    _i = i;
    notifyListeners();
  }

  void hasFocus(bool hasFocus) {
    _hasFocus = hasFocus;
    notifyListeners();
  }

  void setChartData(bool showAnimation) {
    if (showAnimation) {
      _chartData = SleepInput.chartData();
    } else {
      _chartData = [];
    }
    notifyListeners();
  }

  void dereaseSleepDataList({@required int? i}) {
    _sleepDataList.removeAt(i!);
    _color!.removeAt(i);
    notifyListeners();
  }

  void setErrorColor(List<bool> error) {
    for (int j = 0; j < _sleepDataList.length; j++) {
      if (error[j]) {
        _color![j] = Colors.red[800]!;
      } else {
        _color![j] = Colors.white;
      }
    }
    notifyListeners();
  }

  void setInitialColor() {
    for (int i = 0; i < _sleepDataList.length; i++) {
      _color![i] = Colors.white;
    }
    notifyListeners();
  }

  void chooseTimeButton(bool pressed) {
    _chooseTimePressed = pressed;
    notifyListeners();
  }
}

class InitialSleepData with ChangeNotifier {
  bool _backButton = false;

  bool get getBackButton => _backButton;

  bool _saveButton = false;

  bool get getSaveButton => _saveButton;

  bool _moreThanOneInputChange = false;

  bool get getMoreThanOneInputChange => _moreThanOneInputChange;

  void backButtonPressed(bool pressed) {
    _backButton = pressed;
    notifyListeners();
  }

  void saveButtonPressed(bool pressed) {
    _saveButton = pressed;
    notifyListeners();
  }

  void moreThanOneInputChange(bool more) {
    _moreThanOneInputChange = more;
    notifyListeners();
  }

  void setDateFormat() {
    notifyListeners();
  }
}
