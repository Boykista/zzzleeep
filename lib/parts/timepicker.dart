import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';

class TimePicker {
  static Future chooseTime(
      {@required BuildContext? context,
      @required bool? fallenAsleep,
      @required int? i}) async {
    var sleepDataProvider =
        Provider.of<SleepDataProvider>(context!, listen: false);
    String hour = '';
    String minute = '';
    final newTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      hourLabelText: '',
      minuteLabelText: '',
      initialTime: fallenAsleep!
          ? const TimeOfDay(hour: 22, minute: 0)
          : const TimeOfDay(hour: 6, minute: 0),
      builder: (BuildContext? context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      newTime.hour < 10 ? hour = '0${newTime.hour}' : hour = '${newTime.hour}';
      newTime.minute < 10
          ? minute = '0${newTime.minute}'
          : minute = '${newTime.minute}';
      if (fallenAsleep) {
        sleepDataProvider.setFallenAsleep(i: i, fallenAsleep: '$hour:$minute');
      } else {
        sleepDataProvider.setWokenUp(i: i, wokenUp: '$hour:$minute');
      }
    } else {
      return;
    }
  }
}
