import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'sleepinput.g.dart';

@HiveType(typeId: 0)
class SleepData extends HiveObject {
  @HiveField(0)
  DateTime? date;
  @HiveField(1)
  String fallenAsleep;
  @HiveField(2)
  String wokenUp;
  @HiveField(3)
  String notes;
  @HiveField(4)
  int hours;
  @HiveField(5)
  int minutes;
  @HiveField(6)
  String? keyDate;
  @HiveField(7)
  List<SleepData>? list;
  SleepData({
    @required this.date,
    this.fallenAsleep = '--:--',
    this.wokenUp = '--:--',
    this.hours = 0,
    this.minutes = 0,
    this.notes = '',
  }) {
    DateFormat dateInString = DateFormat('yyyy-MM-dd');
    date = dateInString.parse(dateInString.format(date!));
    keyDate = dateInString.format(date!);
  }

  static Box<dynamic> getBox() => Hive.box('sleepdata');
}
