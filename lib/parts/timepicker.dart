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
      initialTime: fallenAsleep!
          ? TimeOfDay(hour: 22, minute: 0)
          : TimeOfDay(hour: 6, minute: 0),
      // confirmText: 'OK',
      // cancelText: 'Otkaži',
      // helpText: 'Odredi vrijeme',
      builder: (BuildContext? context, Widget? child) {
        // Theme(
        //   data: ThemeData.light().copyWith(
        //     colorScheme: ColorScheme.light().copyWith(
        //       primary: Colors.yellow[800],
        //     ),
        //   ),
        //   child: child,
        // );
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
