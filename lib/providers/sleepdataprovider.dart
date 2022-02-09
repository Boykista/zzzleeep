import 'package:flutter/cupertino.dart';
import 'package:zzzleep/models/sleepinput.dart';

class SleepDataProvider with ChangeNotifier {
  final SleepData _sleepData = SleepData(date: DateTime.now());

  List<SleepData> _sleepDataList = [];

  List<SleepData> get getSleepDataList => _sleepDataList;

  void setSleepDataList({@required List<SleepData>? sleepData}) {
    _sleepDataList = sleepData!;
    notifyListeners();
  }

  void increaseSleepDataList({@required SleepData? sleepData}) {
    _sleepDataList.add(sleepData!);
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
}
