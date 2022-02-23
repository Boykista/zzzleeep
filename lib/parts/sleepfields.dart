import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/parts/timepicker.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';

class ShowData extends StatelessWidget {
  const ShowData(
      {Key? key,
      required this.fontSize,
      this.i,
      @required this.list,
      @required this.sleepData})
      : super(key: key);

  final double fontSize;
  final int? i;
  final bool? list;
  final SleepData? sleepData;
  @override
  Widget build(BuildContext context) {
    if (list!) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hours(
              fontSize: fontSize,
              hours: sleepData!.hours,
              minutes: sleepData!.minutes,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Time(
                fontSize: fontSize,
                fallenAsleep: sleepData!.fallenAsleep,
                wokenUp: sleepData!.wokenUp,
                list: list,
              ),
            )
          ],
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hours(
                fontSize: fontSize + 2,
                hours: sleepData!.hours,
                minutes: sleepData!.minutes,
              ),
              Time(
                fontSize: fontSize + 2,
                fallenAsleep: sleepData!.fallenAsleep,
                wokenUp: sleepData!.wokenUp,
                list: list,
                i: i,
              )
            ],
          ));
    }
  }
}

class Time extends StatelessWidget {
  const Time({
    Key? key,
    required this.fontSize,
    @required this.fallenAsleep,
    @required this.wokenUp,
    @required this.list,
    this.i,
  }) : super(key: key);

  final double fontSize;
  final String? fallenAsleep;
  final String? wokenUp;
  final bool? list;
  final int? i;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    if (list!) {
      return Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.airline_seat_individual_suite_sharp,
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              LimitedBox(
                maxWidth: screenWidth / 3,
                child: Text(
                  fallenAsleep!,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Icon(
                Icons.alarm,
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              LimitedBox(
                maxWidth: screenWidth / 3,
                child: Text(
                  wokenUp!,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          TextButton(
            onPressed: () {
              TimePicker.chooseTime(context: context, fallenAsleep: true, i: i)
                  .then((value) {
                List? hourMinute = SleepInput.hourCalculator(
                    fallenAsleep:
                        sleepDataProvider.getSleepDataList[i!].fallenAsleep,
                    wokenUp: sleepDataProvider.getSleepDataList[i!].wokenUp);
                if (!hourMinute.contains('--:--')) {
                  sleepDataProvider.calculateHoursMinutes(
                      i: i, hours: hourMinute[0], minutes: hourMinute[1]);
                }
              });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.airline_seat_individual_suite_sharp,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  fallenAsleep!,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: sleepDataProvider.getColor![i!]),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              TimePicker.chooseTime(context: context, fallenAsleep: false, i: i)
                  .then((value) {
                List? hourMinute = SleepInput.hourCalculator(
                    fallenAsleep:
                        sleepDataProvider.getSleepDataList[i!].fallenAsleep,
                    wokenUp: sleepDataProvider.getSleepDataList[i!].wokenUp);
                if (!hourMinute.contains('--:--')) {
                  sleepDataProvider.calculateHoursMinutes(
                      i: i, hours: hourMinute[0], minutes: hourMinute[1]);
                  //sleepDataProvider.prikaziNulu(prikaziNulu: true);

                }
              });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.alarm,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  wokenUp!,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: sleepDataProvider.getColor![i!]),
                )
              ],
            ),
          ),
        ],
      );
    }
  }
}

class Hours extends StatelessWidget {
  const Hours({
    Key? key,
    required this.fontSize,
    @required this.hours,
    @required this.minutes,
  }) : super(key: key);

  final double fontSize;
  final int? hours;
  final int? minutes;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(
        Icons.access_time,
        color: Colors.white,
      ),
      const SizedBox(
        width: 15,
      ),
      Text(
        hours == 0 && minutes! > 0
            ? '$minutes min'
            : hours! > 0 && minutes == 0
                ? '$hours'
                : hours! > 0 && minutes! > 0
                    ? minutes! < 10
                        ? '$hours:0$minutes'
                        : '$hours:$minutes'
                    : '--:--',
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      )
    ]);
  }
}
