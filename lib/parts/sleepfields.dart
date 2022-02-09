import 'package:flutter/material.dart';
import 'package:zzzleep/models/sleepinput.dart';

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
            Time(
              fontSize: fontSize,
              fallenAsleep: sleepData!.fallenAsleep,
              wokenUp: sleepData!.wokenUp,
              list: list,
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
              TextButton(
                onPressed: () {},
                child: Hours(
                  fontSize: fontSize + 2,
                  hours: sleepData!.hours,
                  minutes: sleepData!.minutes,
                ),
              ),
              Time(
                fontSize: fontSize + 2,
                fallenAsleep: sleepData!.fallenAsleep,
                wokenUp: sleepData!.wokenUp,
                list: list,
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
  }) : super(key: key);

  final double fontSize;
  final String? fallenAsleep;
  final String? wokenUp;
  final bool? list;
  @override
  Widget build(BuildContext context) {
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
              Text(
                fallenAsleep!,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
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
              Text(
                wokenUp!,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
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
              print('AAAAAAAAAAA fallen asleep');
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
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              print('AAAAAAAAAAA woken up');
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
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
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
        '${hours == 0 ? '--' : hours}:${minutes == 0 ? '--' : minutes}',
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      )
    ]);
  }
}
