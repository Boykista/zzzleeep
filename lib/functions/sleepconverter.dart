import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:intl/intl.dart';

class SleepInput {
  SleepInput() {
    // openBox();
  }
  // void openBox() async {
  //   await Hive.openBox('sleepdata');
  // }

  static Future addNewDate() async {
    // await Hive.openBox<SleepData>('sleepdata');

    final sleepData = Hive.box('sleepdata');
    SleepData sleepinput = SleepData(date: DateTime.now());

    if (sleepData.isEmpty) {
      sleepData.put(sleepinput.keyDate, [sleepinput]);
      print('DODANO 1');
    } else {
      final lastData = sleepData.getAt(sleepData.length - 1) as List;
      SleepData lastSleepData = lastData[0];
      DateTime today =
          SleepInput.dateConverter(dateData: DateTime.now(), toHive: true);

      if (lastSleepData.date!.isBefore(today)) {
        sleepData.put(sleepinput.keyDate, [sleepinput]);
        print('DODANO 2');
      } else {
        print('DANAŠNJI DATUM NIJE POSLIJE ZADNJEG IZ BAZE');
      }
    }
  }

  static Future saveInputs({@required List<SleepData>? sleepInput}) async {
    // await Hive.openBox<SleepData>('sleepdata');
    // List sleepList = [];
    // for (int i = 0; i < sleepList.length; i++) {
    //   sleepList.add(value)
    // }
    final sleepData = Hive.box('sleepdata');

    sleepData.put(sleepInput?[0].keyDate, sleepInput);
    print('DDDOOODAAANOOOO $sleepInput');
  }

  static dateConverter({@required DateTime? dateData, @required bool? toHive}) {
    if (toHive!) {
      DateFormat date = DateFormat('yyyy-MM-dd');
      return date.parse((date.format(dateData!)));
    } else {
      DateFormat date = DateFormat('dd.MM.yyyy.');
      return date.format(dateData!);
    }
  }

  static SleepData hoursMinutesConverter(
      {@required List<SleepData>? sleepdata}) {
    int hours = 0;
    int minutes = 0;
    SleepData sleepInput = SleepData(date: sleepdata?[0].date);
    for (int i = 0; i < sleepdata!.length; i++) {
      minutes += sleepdata[i].minutes;
      hours += sleepdata[i].hours;
    }
    if (minutes > 60) {
      hours += (minutes / 60).truncate();
      minutes = ((minutes / 60 - (minutes / 60).truncate()) * 60).truncate();
    }
    if (minutes == 60) {
      minutes = 0;
    }
    sleepInput.hours = hours;
    sleepInput.minutes = minutes;
    return sleepInput;
  }

  static String fallenAsleepConverter({@required List<SleepData>? sleepData}) {
    String fallenAsleep = '';
    for (int i = 0; i < sleepData!.length; i++) {
      fallenAsleep += sleepData[i].fallenAsleep + ' ';
    }
    return fallenAsleep;
  }

  static String wokenUpConverter({@required List<SleepData>? sleepData}) {
    String wokenUp = '';
    for (int i = 0; i < sleepData!.length; i++) {
      wokenUp += sleepData[i].wokenUp + ' ';
    }
    return wokenUp;
  }

  static List hourCalculator(
      {@required String? fallenAsleep, @required String? wokenUp}) {
    if (fallenAsleep != '--:--' && wokenUp != '--:--') {
      int hrsFrom = int.parse(fallenAsleep!.split(':')[0]);
      int hrsTil = int.parse(wokenUp!.split(':')[0]);
      int minFrom = int.parse(fallenAsleep.split(':')[1]);
      int minTil = int.parse(wokenUp.split(':')[1]);
      int hourSlept = 0;
      int minSlept = 0;
      if (hrsFrom > hrsTil) {
        hourSlept = 24 - hrsFrom + hrsTil;
        if (minFrom > minTil) {
          minSlept = 60 - minFrom + minTil;
          hourSlept = 24 - hrsFrom + hrsTil - 1;
        } else if (minFrom < minTil) {
          minSlept = minTil - minFrom;
        } else {
          minSlept = 0;
        }
      } else if (hrsFrom < hrsTil) {
        hourSlept = hrsTil - hrsFrom;
        if (minFrom > minTil) {
          minSlept = 60 - minFrom + minTil;
          hourSlept = hrsTil - hrsFrom - 1;
        } else if (minFrom < minTil) {
          minSlept = minTil - minFrom;
        } else {
          minSlept = 0;
        }
      } else {
        hourSlept = 0;
        minSlept = minTil - minFrom;
      }
      print('SPAVANJE: $hourSlept:$minSlept');
      return [hourSlept, minSlept];
    } else {
      return [fallenAsleep, wokenUp];
    }
  }
}
