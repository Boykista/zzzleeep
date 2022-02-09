import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/parts/sleepfields.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';

class SetSleepTime extends StatefulWidget {
  const SetSleepTime({Key? key}) : super(key: key);

  @override
  _SetSleepTimeState createState() => _SetSleepTimeState();
}

Color? indigo = Colors.indigo[900];
double fontSize = 21;
int currentIndex = 0;
bool moreThanOneInput = false;

class _SetSleepTimeState extends State<SetSleepTime> {
  @override
  Widget build(BuildContext context) {
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    if (sleepDataProvider.getSleepDataList.length > 1) {
      moreThanOneInput = true;
    } else {
      moreThanOneInput = false;
    }
    String date = SleepInput.dateConverter(
        dateData: sleepDataProvider.getSleepDataList[0].date, toHive: false);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    print('SCREENHEIGHT $screenHeight');
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
            // child: GestureDetector(
            //   onHorizontalDragStart: (details) {
            //     Navigator.pop(context);
            //   },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(10, 40, 10, 40),
              decoration: BoxDecoration(
                  color: indigo?.withOpacity(0.5),
                  border: Border.all(
                    color: Colors.indigo,
                  ),
                  borderRadius: BorderRadius.circular(30)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -20,
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
                            fontSize: fontSize + 3, color: Colors.indigo[900]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 150,
                  //   width: width,
                  //   child: Text(
                  //     'Notes/Dreams...',
                  //     style: TextStyle(
                  //       fontSize: fontSize,
                  //       color: Colors.white,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxHeight: screenHeight * 0.3),
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  sleepDataProvider.getSleepDataList.length,
                              itemBuilder: (BuildContext context, int i) {
                                SleepData sleepData =
                                    sleepDataProvider.getSleepDataList[i];
                                print('IIIIIIIIIIIIIII: $i');
                                return Column(
                                  children: [
                                    i > 0
                                        ? Divider(
                                            color: Colors.indigo,
                                            thickness: 1.5,
                                          )
                                        : SizedBox(),
                                    ShowData(
                                      sleepData: sleepData,
                                      fontSize: fontSize,
                                      list: false,
                                      i: i,
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Notes/Dreams...',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: TextField(
                              textInputAction: TextInputAction.newline,
                              maxLines: 20,
                              onTap: () {},
                              style: TextStyle(
                                  fontSize: fontSize, color: Colors.white),
                              decoration: InputDecoration(
                                isDense: false,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(8, 15, 8, 15),
                                labelStyle: TextStyle(
                                    fontSize: fontSize + 4,
                                    color: Colors.indigo),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ),
          // Positioned(
          //   top: 70,
          //   width: width - 40,
          //   left: width / 2 - 180,
          //   child: SingleChildScrollView(
          //     child: ListView.builder(
          //         shrinkWrap: true,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemCount: sleepDataProvider.getSleepDataList.length,
          //         itemBuilder: (BuildContext context, int i) {
          //           SleepData sleepData = sleepDataProvider.getSleepDataList[i];
          //           return ShowData(
          //             sleepData: sleepData,
          //             fontSize: fontSize,
          //             list: false,
          //           );
          //         }),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        color: indigo!.withOpacity(0.58),
        backgroundColor: Colors.transparent,
        height: 60,
        index: currentIndex,
        onTap: (index) async {
          print('AAAAAAAAAAA ADDED');
          setState(() {
            currentIndex = index;
          });
          if (index == 0) {
            SleepData sleepDataPlus =
                SleepData(date: sleepDataProvider.getSleepDataList[0].date);
            sleepDataProvider.increaseSleepDataList(sleepData: sleepDataPlus);
          }
        },
        items: [
          Icon(
            Icons.add,
            color: currentIndex == 0 ? Colors.indigo[900] : Colors.white,
            size: 30,
          ),
          Icon(
            Icons.save,
            color: currentIndex == 1 ? Colors.indigo[900] : Colors.white,
            size: 30,
          )
        ],
      ),
    );
  }
}
