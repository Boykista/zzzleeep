import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zzzleep/features/sharedpreferences.dart';
import 'package:zzzleep/functions/sleepdatachart.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:intl/intl.dart';

class SleepInput {
  static Future addNewDate() async {
    final sleepData = Hive.box('sleepdata');
    if (sleepData.isEmpty) {
      SleepData sleepinput = SleepData(date: DateTime.now());
      sleepData.put(sleepinput.keyDate, [sleepinput]);
    } else {
      final lastData = sleepData.getAt(sleepData.length - 1) as List;
      SleepData lastSleepData = lastData[0];
      DateTime today =
          SleepInput.dateConverter(dateData: DateTime.now(), toHive: true);
      if (lastSleepData.date!.isBefore(today)) {
        int dayDifference = today.difference(lastSleepData.date!).inDays;
        for (int i = 0; i < dayDifference; i++) {
          SleepData newSleepData =
              SleepData(date: lastSleepData.date!.add(Duration(days: i + 1)));
          sleepData.put(newSleepData.keyDate, [newSleepData]);
        }
      } else {}
    }
  }

  static Future saveInputs({@required List<SleepData>? sleepInput}) async {
    final sleepData = Hive.box('sleepdata');
    sleepData.put(sleepInput?[0].keyDate, sleepInput);
  }

  static dateConverter({@required DateTime? dateData, @required bool? toHive}) {
    if (toHive!) {
      DateFormat date = DateFormat('yyyy-MM-dd');
      return date.parse((date.format(dateData!)));
    } else {
      DateFormat date = SleepInput.dateFormater(false, false)!;
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
    if (minutes >= 60) {
      hours += (minutes / 60).truncate();
      minutes = ((minutes / 60 - (minutes / 60).truncate()) * 60).round();
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
          minutes = sleepDataList[j].minutes;
          hours += sleepDataList[j].hours;
          hours += (minutes / 60);
          dontAdd = false;
        }
      }
      if (!dontAdd) {
        chartData
            .add(SleepChartData(hours: hours, date: sleepDataList[0].date));
      }
    }
    return chartData;
  }

  static Map calculateData() {
    List? wholeSleepDataList = [];
    final boxData = Hive.box('sleepdata');
    int hours = 0;
    int minutes = 0;
    double total = 0;
    int dividerLength = 0;
    double max = 0;
    int maxHours = 0;
    int maxMinutes = 0;
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
          maxHours += sleepDataList[j].hours;
          maxMinutes += sleepDataList[j].minutes;
        }
      }
      if (max < (maxHours + maxMinutes / 60)) {
        max = (maxHours + maxMinutes / 60);
      } else {
        max = max;
      }
      maxHours = 0;
      maxMinutes = 0;
    }
    dividerLength == 0 ? dividerLength = 1 : dividerLength = dividerLength;

    total = (hours + minutes / 60) / dividerLength;

    hours = total.truncate();
    minutes = ((total - hours) * 60).round();
    average = [hours, minutes];
    Map calculatedData = {'average': average, 'max': max};

    return calculatedData;
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
      point = '$hours h';
    } else {
      if (minutes < 10) {
        point = '$hours:0$minutes';
      } else {
        point = '$hours:$minutes';
      }
    }

    return point;
  }

  static String? pointX({@required DateTime? pointX}) {
    DateFormat dateFormat = SleepInput.dateFormater(false, true)!;
    String date = dateFormat.format(pointX!);
    return date;
  }

  static DateFormat? dateFormater(bool pressed, bool tooltip) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    int counter = SimplePreferences.getCounter();
    if (counter > 3) {
      counter = 0;
    }
    if (counter == 0) {
      dateFormat = DateFormat('dd/MM/yyyy');
      if (tooltip) {
        dateFormat = DateFormat('dd/MM');
      }
    } else if (counter == 1) {
      dateFormat = DateFormat('MM/dd/yyyy');
      if (tooltip) {
        dateFormat = DateFormat('MM/dd');
      }
    } else if (counter == 2) {
      dateFormat = DateFormat('d.M.yyyy.');
      if (tooltip) {
        dateFormat = DateFormat('d.M.');
      }
    } else if (counter == 3) {
      dateFormat = DateFormat('EEEE');
    }
    if (pressed) {
      counter++;
      SimplePreferences.setCounter(counter: counter);
    }

    return dateFormat;
  }

  static List<bool>? checkError({@required List<SleepData>? sleepData}) {
    List<bool> error = [];
    for (int i = 0; i < sleepData!.length; i++) {
      if (sleepData[i].hours < 0 || sleepData[i].minutes < 0) {
        error.add(true);
      } else {
        if (sleepData[i].fallenAsleep == sleepData[i].wokenUp) {
          error.add(true);
        } else {
          error.add(false);
        }
      }
    }
    return error;
  }
}
