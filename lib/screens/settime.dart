import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/parts/sleepfields.dart';
import 'package:zzzleep/providers/animationprovider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SetSleepTime extends StatefulWidget {
  const SetSleepTime({Key? key}) : super(key: key);

  @override
  _SetSleepTimeState createState() => _SetSleepTimeState();
}

Color? indigo = Colors.indigo[900];
double fontSize = 21;
//int currentIndex = 0;
bool moreThanOneInput = false;

class _SetSleepTimeState extends State<SetSleepTime> {
  bool focus = false;
  late StreamSubscription<bool> keyboardSubscription;
  @override
  void initState() {
    super.initState();
    var animationProvider =
        Provider.of<AnimationProvider>(context, listen: false);
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) async {
      setState(() {
        keyboardVisibilityController.isVisible ? focus = true : focus = false;
      });
      if (!focus) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      animationProvider.setFocus(focus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    var animationProvider =
        Provider.of<AnimationProvider>(context, listen: false);
    animationProvider.displayAll();
    keyboardSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    var animationProvider = Provider.of<AnimationProvider>(context);
    String date = '';
    if (sleepDataProvider.getSleepDataList.isNotEmpty) {
      date = SleepInput.dateConverter(
          dateData: sleepDataProvider.getSleepDataList[0].date, toHive: false);
      if (sleepDataProvider.getSleepDataList.length > 1) {
        moreThanOneInput = true;
      } else {
        moreThanOneInput = false;
      }
    }
    sleepDataProvider.getChooseTimeButton ? focus = false : focus = focus;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return sleepDataProvider.getSleepDataList.isNotEmpty
        ? Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SafeArea(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(
                        10, 40, 10, animationProvider.getFocus ? 20 : 90),
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
                                  fontSize: fontSize + 3,
                                  color: Colors.indigo[900]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOutQuart,
                              constraints: BoxConstraints(
                                  maxHeight: screenHeight > 570
                                      ? focus
                                          ? screenHeight * 0.0
                                          : screenHeight * 0.5
                                      : 50),
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: sleepDataProvider
                                        .getSleepDataList.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      SleepData sleepData =
                                          sleepDataProvider.getSleepDataList[i];
                                      return Column(
                                        children: [
                                          i > 0
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    const Divider(
                                                      color: Colors.indigo,
                                                      thickness: 1.5,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          sleepDataProvider
                                                              .dereaseSleepDataList(
                                                                  i: i);
                                                        },
                                                        icon: const Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ))
                                                  ],
                                                )
                                              : const SizedBox(),
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
                            const SizedBox(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: TextField(
                                    autofocus: false,
                                    controller:
                                        sleepDataProvider.getNotesController,
                                    textInputAction: TextInputAction.newline,
                                    maxLines: 20,
                                    onTap: () {},
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      isDense: false,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          8, 15, 8, 15),
                                      labelStyle: TextStyle(
                                          fontSize: fontSize + 4,
                                          color: Colors.indigo),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    onChanged: (value) {
                                      sleepDataProvider.setNotes(notes: value);
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
