import 'dart:io';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/parts/sleepfields.dart';
import 'package:zzzleep/providers/animationprovider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';
import 'package:zzzleep/screens/chart.dart';
import 'package:zzzleep/screens/settime.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SleepDates(indigo: indigo, fontSize: fontSize),
            ),
          ),
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

class _SleepDatesState extends State<SleepDates> with TickerProviderStateMixin {
  bool moreThanOneInput = false;
  AnimationController? _animationController2,
      _animationController,
      _slideController;
  Animation<double>? scale2, scale;
  Animation<Offset>? slide, slide2;
  List wholeList = [];

  void bottomNavigationCallBack(bool savedInputs) {
    if (savedInputs) {
      wholeList = [];
    }
  }

  @override
  void initState() {
    _animationController2 = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: Duration(seconds: 1));
    scale2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController2!, curve: Curves.easeOutExpo));

    _animationController = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: Duration(seconds: 1));
    scale = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeOutExpo));

    _slideController = AnimationController(
        vsync: this,
        animationBehavior: AnimationBehavior.preserve,
        duration: Duration(seconds: 1));

    slide = Tween<Offset>(begin: Offset.zero, end: Offset(0, 1)).animate(
        CurvedAnimation(parent: _slideController!, curve: Curves.easeOutExpo));
    slide2 = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero).animate(
        CurvedAnimation(parent: _slideController!, curve: Curves.easeOutExpo));
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    _animationController!.dispose();
    _animationController2!.dispose();
    _slideController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var animationProvider =
        Provider.of<AnimationProvider>(context, listen: false);
    var sleepDataProvider =
        Provider.of<SleepDataProvider>(context, listen: false);

    return FutureBuilder(
        future: Hive.openBox('sleepdata'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              SleepInput.addNewDate();
              return ValueListenableBuilder<Box<dynamic>>(
                  valueListenable: SleepData.getBox().listenable(),
                  builder: (context, value, _) {
                    final data = Hive.box('sleepdata');
                    animationProvider.setOpacityListLength(data.length);
                    wholeList.clear();
                    return SizedBox.expand(
                      child: Stack(
                        children: [
                          SlideTransition(
                            position: slide!,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int i) {
                                      final sleepData = data.getAt(i) as List;
                                      List<SleepData> sleepInputList =
                                          List<SleepData>.from(sleepData);
                                      wholeList.add(sleepInputList);
                                      sleepDataProvider.setWholeList =
                                          sleepInputList;

                                      print(
                                          'LENGTH POJEDINACNOG SLEEP INPUTA $sleepInputList: ${sleepInputList.length}');
                                      SleepData sleepInput =
                                          SleepData(date: sleepData[0].date);
                                      // print(
                                      //     'WHOLEEEEEEEEEEEEEEEEEEEEE ${sleepDataProvider.getWholeList}');
                                      if (sleepInputList.length > 1) {
                                        moreThanOneInput = true;
                                        sleepInput =
                                            SleepInput.hoursMinutesConverter(
                                                sleepdata: sleepInputList);
                                        sleepInput.fallenAsleep =
                                            SleepInput.fallenAsleepConverter(
                                                sleepData: sleepInputList);
                                        sleepInput.wokenUp =
                                            SleepInput.wokenUpConverter(
                                                sleepData: sleepInputList);
                                      } else {
                                        moreThanOneInput = false;
                                      }
                                      String date = SleepInput.dateConverter(
                                          dateData: sleepInputList[0].date,
                                          toHive: false);

                                      return DelayedDisplay(
                                        delay: Duration(
                                            milliseconds: data.length < 5
                                                ? i * 700
                                                : i < data.length - 5
                                                    ? 0
                                                    : (i - (data.length - 5)) *
                                                        700),
                                        slidingCurve: Curves.bounceOut,
                                        child: Dates(
                                          indigo: indigo,
                                          fontSize: fontSize,
                                          sleepInput: sleepInput,
                                          sleepInputList: sleepInputList,
                                          i: i,
                                          date: date,
                                          animationController2:
                                              _animationController2,
                                          scale2: scale2,
                                          wholeList: wholeList,
                                          animationController:
                                              _animationController,
                                          scale: scale,
                                          callBack: bottomNavigationCallBack,
                                        ),
                                      );
                                    },
                                    itemCount: data.length,
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox.expand(
                            child: ScaleTransition(
                              scale: scale2!,
                              child: const SetSleepTime(),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: BottomNavigationBarStack(
                                animationController2: _animationController2,
                                animationController: _animationController,
                                slideController: _slideController,
                                callBack: bottomNavigationCallBack),
                          ),
                          SlideTransition(
                              position: slide2!, child: SleepChart())
                        ],
                      ),
                    );
                  });
            }
          } else {
            return const SizedBox();
          }
        });
  }
}

class Dates extends StatefulWidget {
  Dates({
    Key? key,
    @required this.indigo,
    @required this.fontSize,
    @required this.sleepInput,
    @required this.sleepInputList,
    @required this.i,
    @required this.date,
    @required this.animationController2,
    @required this.scale2,
    @required this.wholeList,
    @required this.animationController,
    @required this.scale,
    @required this.callBack,
  }) : super(key: key);
  AnimationController? animationController, animationController2;

  Animation<double>? scale; //, scale2;
  Color? indigo;
  double? fontSize;
  SleepData? sleepInput;
  List<SleepData>? sleepInputList;
  int? i;
  String? date;
  int? millisecondsDelay;

  Animation<double>? scale2;
  List? wholeList;
  Function? callBack;

  @override
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var animationProvider = Provider.of<AnimationProvider>(context);
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: ((BuildContext context, Widget? child) => AnimatedOpacity(
            curve: Curves.easeInExpo,
            duration: const Duration(seconds: 1),
            opacity: animationProvider.getOpacity[widget.i!],
            child: ScaleTransition(
              scale: widget.scale!,
              child: Stack(
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
                      fontSize: widget.fontSize!,
                      i: widget.i,
                      list: true,
                      sleepData: moreThanOneInput
                          ? widget.sleepInput
                          : widget.sleepInputList![0],
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
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            overlayColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return widget.indigo?.withOpacity(0.5);
                              }
                            })),
                        onPressed: () async {
                          sleepDataProvider.setSleepDataList(
                              sleepData: widget.wholeList![widget.i!]);
                          sleepDataProvider.setNotes(
                              notes: widget.wholeList![widget.i!][0].notes);
                          animationProvider.displayOne(widget.i!);
                          animationProvider.setHeight(true);
                          sleepDataProvider.itemIndex(widget.i!);
                          await Future.delayed(
                              const Duration(milliseconds: 1500));
                          widget.animationController!.forward();
                          await Future.delayed(
                              const Duration(milliseconds: 350));
                          widget.animationController2!.forward();
                          sleepDataProvider.secondScreen(true);
                          // animationProvider.backPressed(false);
                          await Future.delayed(
                              const Duration(milliseconds: 850));
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
                        widget.date!,
                        style: TextStyle(
                            fontSize: widget.fontSize! + 3,
                            color: Colors.indigo[900]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class BottomNavigationBarStack extends StatefulWidget {
  BottomNavigationBarStack(
      {Key? key,
      this.animationController,
      this.animationController2,
      this.slideController,
      this.callBack})
      : super(key: key);
  AnimationController? animationController,
      animationController2,
      slideController;
  Function? callBack;
  @override
  _BottomNavigationBarStackState createState() =>
      _BottomNavigationBarStackState();
}

class _BottomNavigationBarStackState extends State<BottomNavigationBarStack> {
  int currentIndex = 1;
  int currentIndex2 = 0;
  bool chartShown = false;

  @override
  Widget build(BuildContext context) {
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);

    if (sleepDataProvider.getSecondScreen) {
      var animationProvider = Provider.of<AnimationProvider>(context);
      return AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: animationProvider.getHeight,
        child: Row(
          children: [
            Expanded(
                child: BottomAppBarItem(
              i: 0,
              animationController: widget.animationController,
              animationController2: widget.animationController2,
            )),
            Expanded(
                child: BottomAppBarItem(
              i: 1,
              animationController: widget.animationController,
              animationController2: widget.animationController2,
            )),
            Expanded(
                child: BottomAppBarItem(
              i: 2,
              animationController: widget.animationController,
              animationController2: widget.animationController2,
            )),
          ],
        ),
      );
    } else {
      var animationProvider = Provider.of<AnimationProvider>(context);
      return AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: 75 - animationProvider.getHeight,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.indigo[900]!.withOpacity(0.95),
              onPressed: () {
                !chartShown
                    ? widget.slideController!.forward()
                    : widget.slideController!.reverse();
                setState(() {
                  chartShown ? chartShown = false : chartShown = true;
                });
              },
              child: !chartShown
                  ? const FaIcon(FontAwesomeIcons.chartLine)
                  : const Icon(Icons.arrow_back_ios_new)),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            notchMargin: 6,
            color: Colors.indigo[900]!.withOpacity(0.95),
            child: const SizedBox(height: 50),
            shape: const CircularNotchedRectangle(),
          ),
        ),
      );
    }
  }
}

class BottomAppBarItem extends StatefulWidget {
  BottomAppBarItem(
      {Key? key,
      @required this.i,
      @required this.animationController,
      @required this.animationController2})
      : super(key: key);
  AnimationController? animationController, animationController2;
  int? i;

  @override
  State<BottomAppBarItem> createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<BottomAppBarItem> {
  @override
  Widget build(BuildContext context) {
    var animationProvider = Provider.of<AnimationProvider>(context);
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: Colors.indigo[900]!.withOpacity(0.85),
        onPressed: () async {
          if (widget.i == 0) {
            //sleepDataProvider.setWholeListToEmpty();
            // sleepDataProvider.dontUpdateSleepData();
            animationProvider.setHeight(false);

            await Future.delayed(const Duration(milliseconds: 850));
            widget.animationController!.reverse();
            // animationProvider.backPressed(true);
            widget.animationController2!.reverse();

            await Future.delayed(const Duration(milliseconds: 850));
            for (int i = 0;
                i < sleepDataProvider.getSleepDataList.length;
                i++) {
              sleepDataProvider.setFallenAsleep(i: i, fallenAsleep: '--:--');
              sleepDataProvider.setWokenUp(i: i, wokenUp: '--:--');
              sleepDataProvider.calculateHoursMinutes(
                  i: i, hours: 0, minutes: 0);
            }
            animationProvider.displayAll();
            sleepDataProvider.secondScreen(false);
          } else if (widget.i == 1) {
            SleepData sleepDataPlus =
                SleepData(date: sleepDataProvider.getSleepDataList[0].date);
            sleepDataProvider.increaseSleepDataList(sleepData: sleepDataPlus);
          } else {
            //sleepDataProvider.setWholeListToEmpty();
            SleepInput.saveInputs(
                sleepInput: sleepDataProvider.getSleepDataList);

            animationProvider.setHeight(false);
            widget.animationController2!.reverse();
            await Future.delayed(const Duration(milliseconds: 850));
            widget.animationController!.reverse();
            await Future.delayed(const Duration(milliseconds: 850));
            animationProvider.displayAll();
            sleepDataProvider.secondScreen(false);
          }
        },
        child: Icon(
          widget.i == 0
              ? Icons.arrow_back_ios_new
              : widget.i == 1
                  ? Icons.add
                  : Icons.save,
          color: Colors.white,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        notchMargin: 6,
        color: Colors.indigo[900]!.withOpacity(0.85),
        child: const SizedBox(height: 50),
        shape: const CircularNotchedRectangle(),
      ),
    );
  }
}
