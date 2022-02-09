import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/parts/sleepfields.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';

class ListOfDates extends StatelessWidget {
  ListOfDates({Key? key}) : super(key: key);
  double fontSize = 21;
  Color? indigo = Colors.indigo[900];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/night.jpg'),
                      fit: BoxFit.cover))),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  children: [
                    SleepDates(indigo: indigo, fontSize: fontSize),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (value) {
          print('AAAAAAAAAABBBBBBB');
          Hive.box('sleepdata').delete('2022-02-05');
        },
        buttonBackgroundColor: Colors.white,
        color: indigo!.withOpacity(0.58),
        backgroundColor: Colors.transparent,
        height: 60,
        items: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.indigo[900],
                size: 30,
              ))
        ],
      ),
    );
  }
}

class SleepDates extends StatefulWidget {
  const SleepDates({
    Key? key,
    required this.indigo,
    required this.fontSize,
  }) : super(key: key);

  final Color? indigo;
  final double fontSize;

  @override
  State<SleepDates> createState() => _SleepDatesState();
}

class _SleepDatesState extends State<SleepDates> {
  bool moreThanOneInput = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var sleepDataProvider =
        Provider.of<SleepDataProvider>(context, listen: false);
    return FutureBuilder(
        future: Hive.openBox('sleepdata'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              final data = Hive.box('sleepdata');
              print('LEEEEEENNNNNGGGGGGTTTTHHHHHH: ${data.length}');

              SleepInput.addNewDate();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  final sleepData = data.getAt(i) as List;
                  var sleepInputList = List<SleepData>.from(sleepData);
                  print(
                      'LENGTH POJEDINACNOG SLEEP INPUTA $sleepInputList: ${sleepInputList.length}');
                  SleepData sleepInput = SleepData(date: sleepData[0].date);
                  if (sleepInputList.length > 1) {
                    moreThanOneInput = true;
                    sleepInput = SleepInput.hoursMinutesConverter(
                        sleepdata: sleepInputList);
                    sleepInput.fallenAsleep = SleepInput.fallenAsleepConverter(
                        sleepData: sleepInputList);
                    sleepInput.wokenUp =
                        SleepInput.wokenUpConverter(sleepData: sleepInputList);
                  } else {
                    moreThanOneInput = false;
                  }
                  String date = SleepInput.dateConverter(
                      dateData: sleepInputList[0].date, toHive: false);
                  return Stack(
                    children: [
                      Container(
                          height: 130,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 12),
                          decoration: BoxDecoration(
                              color: widget.indigo?.withOpacity(0.5),
                              border: Border.all(
                                color: Colors.indigo,
                              ),
                              borderRadius: BorderRadius.circular(30))),
                      Positioned(
                        top: 55,
                        width: screenWidth - 40,
                        left: screenWidth / 2 - 180,
                        child: ShowData(
                          fontSize: widget.fontSize,
                          i: i,
                          list: true,
                          sleepData: sleepInput,
                        ),
                      ),
                      Container(
                        height: 130,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 4),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                overlayColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return widget.indigo?.withOpacity(0.35);
                                  }
                                })),
                            onPressed: () {
                              print('PRESSED');

                              sleepDataProvider.setSleepDataList(
                                  sleepData: sleepInputList);
                              Navigator.pushNamed(context, '/settime',
                                  arguments: sleepInputList);
                            },
                            child: SizedBox(
                              height: 130,
                              width: screenWidth - 20,
                            )),
                      ),
                      Positioned(
                        left: screenWidth / 2 - 80,
                        width: 160,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            date,
                            style: TextStyle(
                                fontSize: widget.fontSize + 3,
                                color: Colors.indigo[900]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: data.length,
              );
            }
          } else {
            return const SizedBox();
          }
        });
  }
}
