import 'package:flutter/cupertino.dart';
import 'package:zzzleep/models/sleepinput.dart';

class SleepDataProvider with ChangeNotifier {
  List<SleepData> _sleepDataList = [];

  List<SleepData> get getSleepDataList => _sleepDataList;

  bool _prikaziNulu = false;

  bool get getPrikaziNulu => _prikaziNulu;

  TextEditingController _notesController = TextEditingController();

  TextEditingController get getNotesController => _notesController;

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

  void setNotes({@required String? notes}) {
    _sleepDataList[0].notes = notes!;
    _notesController.value = _notesController.value.copyWith(text: notes);
    notifyListeners();
  }

  // void notesController({@required List<SleepData>? sleepData}) {
  //   notifyListeners();
  // }

}
