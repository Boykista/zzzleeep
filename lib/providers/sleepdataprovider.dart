import 'package:flutter/cupertino.dart';
import 'package:zzzleep/models/sleepinput.dart';

class SleepDataProvider with ChangeNotifier {
  List<SleepData> _sleepDataList = [];

  List<SleepData> get getSleepDataList => _sleepDataList;

  bool _prikaziNulu = false;

  bool get getPrikaziNulu => _prikaziNulu;

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

  void calculateHoursMinutes(
      {@required int? i, @required int? hours, @required int? minutes}) {
    _sleepDataList[i!].hours = hours!;
    _sleepDataList[i].minutes = minutes!;
    notifyListeners();
  }

  void prikaziNulu({@required bool? prikaziNulu}) {
    _prikaziNulu = prikaziNulu!;
    notifyListeners();
  }
}
