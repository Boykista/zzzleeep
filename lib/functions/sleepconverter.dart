import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zzzleep/functions/sleepdatachart.dart';
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

    if (sleepData.isEmpty) {
      SleepData sleepinput = SleepData(date: DateTime.now());
      sleepData.put(sleepinput.keyDate, [sleepinput]);
      print('DODANO 1');
    } else {
      final lastData = sleepData.getAt(sleepData.length - 1) as List;
      SleepData lastSleepData = lastData[0];
      DateTime today =
          SleepInput.dateConverter(dateData: DateTime.now(), toHive: true);

      if (lastSleepData.date!.isBefore(today)) {
        int dayDifference = today.difference(lastSleepData.date!).inDays;
        print('RAZLIKA U DANIMA: $dayDifference');
        for (int i = 0; i < dayDifference; i++) {
          SleepData newSleepData =
              SleepData(date: lastSleepData.date!.add(Duration(days: i + 1)));
          print(newSleepData.keyDate);
          sleepData.put(newSleepData.keyDate, [newSleepData]);
        }
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
      minutes = ((minutes / 60 - (minutes / 60).truncate()) * 60).round();
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

  static List<SleepChartData> chartData() {
    List? wholeSleepDataList = [];
    final boxData = Hive.box('sleepdata');
    for (int i = 0; i < boxData.length; i++) {
      final data = boxData.getAt(i) as List;
      wholeSleepDataList.add(data);
    }

    List<SleepChartData> chartData = [];
    DateFormat dateFormat = DateFormat('dd.MM.');
    String date = '';
    bool dontAdd = false;
    for (int i = 0; i < wholeSleepDataList.length; i++) {
      List<SleepData> sleepDataList =
          List<SleepData>.from(wholeSleepDataList[i]);

      double hours = 0;
      int minutes = 0;
      for (int j = 0; j < sleepDataList.length; j++) {
        if (sleepDataList[j].fallenAsleep == '--:--' ||
            sleepDataList[j].wokenUp == '--:--') {
          dontAdd = true;
          continue;
        } else {
          minutes += sleepDataList[j].minutes;
          hours += sleepDataList[j].hours;
          hours += (minutes / 60);
          dontAdd = false;
        }
      }
      if (!dontAdd) {
        date = dateFormat.format(sleepDataList[0].date!);
        chartData.add(SleepChartData(hours: hours, date: date));
      }
    }
    return chartData;
  }

  static List calculateAverage() {
    List? wholeSleepDataList = [];
    final boxData = Hive.box('sleepdata');
    int hours = 0;
    int minutes = 0;
    double total = 0;
    int dividerLength = 0;
    for (int i = 0; i < boxData.length; i++) {
      final data = boxData.getAt(i) as List;
      wholeSleepDataList.add(data);
    }
    dividerLength = wholeSleepDataList.length;
    List average = [];
    for (int i = 0; i < wholeSleepDataList.length; i++) {
      List<SleepData> sleepDataList =
          List<SleepData>.from(wholeSleepDataList[i]);

      for (int j = 0; j < sleepDataList.length; j++) {
        if (sleepDataList[j].fallenAsleep == '--:--' ||
            sleepDataList[j].wokenUp == '--:--') {
          dividerLength--;
          continue;
        } else {
          hours += sleepDataList[j].hours;
          minutes += sleepDataList[j].minutes;
        }
      }
    }

    dividerLength == 0 ? dividerLength = 1 : dividerLength = dividerLength;

    total = (hours + minutes / 60) / dividerLength;

    hours = total.truncate();
    minutes = ((total - hours) * 60).round();

    // if (minutes > 60) {
    //   hours += (minutes / 60).truncate();
    //   minutes = ((minutes / 60 - (minutes / 60).truncate()) * 60).round();
    // }
    // if (minutes == 60) {
    //   minutes = 0;
    // }

    average = [hours, minutes];
    return average;
  }

  static String? pointY({@required double? pointY}) {
    int hours = 0;
    int minutes = 0;
    String point = '';
    hours = (pointY!).truncate();
    minutes = ((pointY - hours) * 60).round();

    if (hours == 0) {
      point = '$minutes min';
    } else if (minutes == 0) {
      point = '$hours hrs';
    } else {
      point = '$hours:$minutes';
    }

    return point;
  }
}
