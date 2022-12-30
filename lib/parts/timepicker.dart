import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';

class TimePicker {
  static Future chooseTime({
    @required BuildContext? context,
    @required bool? fallenAsleep,
    @required int? i,
  }) async {
    var sleepDataProvider =
        Provider.of<SleepDataProvider>(context!, listen: false);

    String hour = '';
    String minute = '';
    final newTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      context: context,
      hourLabelText: '',
      minuteLabelText: '',
      initialTime: TimePicker.initalTime(
          sleepdata: sleepDataProvider.getSleepDataList[i!],
          fallenAsleep: fallenAsleep)!,
      builder: (BuildContext? context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    sleepDataProvider.chooseTimeButton(false);
    if (newTime != null) {
      newTime.hour < 10 ? hour = '0${newTime.hour}' : hour = '${newTime.hour}';
      newTime.minute < 10
          ? minute = '0${newTime.minute}'
          : minute = '${newTime.minute}';

      if (fallenAsleep!) {
        sleepDataProvider.setFallenAsleep(i: i, fallenAsleep: '$hour:$minute');
      } else {
        sleepDataProvider.setWokenUp(i: i, wokenUp: '$hour:$minute');
      }
    } else {
      return;
    }
  }

  static TimeOfDay? initalTime(
      {@required SleepData? sleepdata, @required bool? fallenAsleep}) {
    int hour = 0;
    int minute = 0;
    if (fallenAsleep! && sleepdata!.fallenAsleep == '--:--') {
      return const TimeOfDay(hour: 22, minute: 0);
    } else if (fallenAsleep && sleepdata!.fallenAsleep != '--:--') {
      hour = int.parse(sleepdata.fallenAsleep.split(':')[0]);
      minute = int.parse(sleepdata.fallenAsleep.split(':')[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } else if (!fallenAsleep && sleepdata!.wokenUp == '--:--') {
      return const TimeOfDay(hour: 6, minute: 0);
    } else {
      hour = int.parse(sleepdata!.wokenUp.split(':')[0]);
      minute = int.parse(sleepdata.wokenUp.split(':')[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }
  }
}
