import 'package:flutter/material.dart';
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
      backgroundColor: Colors.indigo[900],
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

class _SleepDatesState extends State<SleepDates>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool moreThanOneInput = false;
  AnimationController? _animationController2,
      _animationController,
      _slideController;
  Animation<double>? scale2, scale;
  Animation<Offset>? slide, slide2;
  List wholeList = [];
  int numberOfNonVisibleAnimation = 6;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _animationController2 = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: const Duration(seconds: 1));
    scale2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController2!, curve: Curves.easeOutExpo));

    _animationController = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: const Duration(seconds: 1));
    scale = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeOutExpo));

    _slideController = AnimationController(
        vsync: this,
        animationBehavior: AnimationBehavior.preserve,
        duration: const Duration(seconds: 1));

    slide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
        CurvedAnimation(parent: _slideController!, curve: Curves.easeOutExpo));
    slide2 = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _slideController!, curve: Curves.easeOutExpo));

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      Hive.close();
      _animationController!.dispose();
      _animationController2!.dispose();
      _slideController!.dispose();
    }
  }

  @override
  void dispose() {
    Hive.close();
    _animationController!.dispose();
    _animationController2!.dispose();
    _slideController!.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    numberOfNonVisibleAnimation = ((screenHeight / 100).truncate() - 2);
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
                    var animationProvider =
                        Provider.of<AnimationProvider>(context, listen: false);
                    // ignore: unused_local_variable
                    var initialSleepData =
                        Provider.of<InitialSleepData>(context);
                    final data = Hive.box('sleepdata');
                    animationProvider.setOpacityListLength(data.length);
                    wholeList.clear();
                    return SizedBox.expand(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SlideTransition(
                            position: slide!,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: SizedBox.expand(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          final sleepData =
                                              data.getAt(i) as List;
                                          List<SleepData> sleepInputList =
                                              List<SleepData>.from(sleepData);
                                          wholeList.add(sleepInputList);
                                          if (wholeList.length ==
                                              data.length) {}
                                          SleepData sleepInput = SleepData(
                                              date: sleepData[0].date);
                                          if (sleepInputList.length > 1) {
                                            moreThanOneInput = true;
                                            sleepInput = SleepInput
                                                .hoursMinutesConverter(
                                                    sleepdata: sleepInputList);
                                            sleepInput.fallenAsleep = SleepInput
                                                .fallenAsleepConverter(
                                                    sleepData: sleepInputList);
                                            sleepInput.wokenUp =
                                                SleepInput.wokenUpConverter(
                                                    sleepData: sleepInputList);
                                          } else {
                                            moreThanOneInput = false;
                                          }
                                          String date =
                                              SleepInput.dateConverter(
                                                  dateData:
                                                      sleepInputList[0].date,
                                                  toHive: false);
                                          return DelayedDisplay(
                                            delay: Duration(
                                                milliseconds: data.length <
                                                        numberOfNonVisibleAnimation
                                                    ? i * 450
                                                    : i <
                                                            data.length -
                                                                numberOfNonVisibleAnimation
                                                        ? 0
                                                        : (i -
                                                                (data.length -
                                                                    numberOfNonVisibleAnimation) +
                                                                1) *
                                                            450),
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
                                              moreThanOneInput:
                                                  moreThanOneInput,
                                            ),
                                          );
                                        },
                                        itemCount: data.length,
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 600, maxHeight: 850),
                              child: SizedBox.expand(
                                child: ScaleTransition(
                                  scale: scale2!,
                                  child: const SetSleepTime(),
                                ),
                              ),
                            ),
                          ),
                          SlideTransition(
                              position: slide2!,
                              child: SleepChart(
                                wholeList: wholeList,
                              )),
                          Positioned(
                            bottom: 0,
                            child: BottomNavigationBarStack(
                              animationController2: _animationController2,
                              animationController: _animationController,
                              slideController: _slideController,
                              wholeList: wholeList,
                            ),
                          ),
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
    @required this.moreThanOneInput,
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
  bool? moreThanOneInput;
  Animation<double>? scale2;
  List? wholeList;

  @override
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var animationProvider = Provider.of<AnimationProvider>(context);
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    var initialSleepDataProvider =
        Provider.of<InitialSleepData>(context, listen: false);
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: ((BuildContext context, Widget? child) => AnimatedOpacity(
            curve: Curves.easeInExpo,
            duration: const Duration(milliseconds: 700),
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
                  Positioned.fill(
                    top: 15,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: ShowData(
                        fontSize: widget.fontSize!,
                        i: widget.i,
                        list: true,
                        sleepData: widget.moreThanOneInput!
                            ? widget.sleepInput
                            : widget.sleepInputList![0],
                      ),
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
                              } else {
                                return Colors.transparent;
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
                          animationProvider.showChartData(false);
                          FocusManager.instance.primaryFocus?.unfocus();
                          await Future.delayed(
                              const Duration(milliseconds: 1000));
                          widget.animationController!.forward();
                          await Future.delayed(
                              const Duration(milliseconds: 350));
                          widget.animationController2!.forward();
                          sleepDataProvider.secondScreen(true);
                          await Future.delayed(
                              const Duration(milliseconds: 850));
                          Hive.close();
                        },
                        child: SizedBox(
                          height: 130,
                          width: screenWidth - 20,
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        SleepInput.dateFormater(true, false);
                        initialSleepDataProvider.setDateFormat();
                      },
                      child: Text(
                        widget.date!,
                        style: TextStyle(
                            fontSize: widget.fontSize! + 3,
                            color: Colors.indigo[900]),
                        textAlign: TextAlign.center,
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(fontWeight: FontWeight.normal)),
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
      @required this.wholeList})
      : super(key: key);
  AnimationController? animationController,
      animationController2,
      slideController;
  List? wholeList;
  @override
  _BottomNavigationBarStackState createState() =>
      _BottomNavigationBarStackState();
}

bool chartShown = false;

class _BottomNavigationBarStackState extends State<BottomNavigationBarStack> {
  int currentIndex = 1;
  int currentIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    if (sleepDataProvider.getSecondScreen) {
      var animationProvider = Provider.of<AnimationProvider>(context);
      return animationProvider.getFocus
          ? const SizedBox()
          : AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: MediaQuery.of(context).size.width,
              height: animationProvider.getHeight,
              child: Row(
                children: [
                  Expanded(
                      child: BottomAppBarItem(
                    wholeList: widget.wholeList,
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
      if (chartShown) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
      return AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: 75 - animationProvider.getHeight,
        child: WillPopScope(
          onWillPop: () async {
            if (chartShown) {
              !chartShown
                  ? widget.slideController!.forward()
                  : widget.slideController!.reverse();
              if (!chartShown) {
                sleepDataProvider.setChartData(true);
              } else {
                await Future.delayed(const Duration(seconds: 1));
                sleepDataProvider.setChartData(false);
              }
              setState(() {
                chartShown ? chartShown = false : chartShown = true;
                animationProvider.showChartData(chartShown);
              });
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                backgroundColor: Colors.indigo[900]!.withOpacity(0.95),
                onPressed: () async {
                  !chartShown
                      ? widget.slideController!.forward()
                      : widget.slideController!.reverse();
                  if (!chartShown) {
                    sleepDataProvider.setChartData(true);
                  } else {
                    await Future.delayed(const Duration(seconds: 1));
                    sleepDataProvider.setChartData(false);
                  }
                  setState(() {
                    chartShown ? chartShown = false : chartShown = true;
                    animationProvider.showChartData(chartShown);
                  });
                },
                child: !chartShown
                    ? const FaIcon(FontAwesomeIcons.chartLine)
                    : const Icon(Icons.format_list_bulleted_rounded)),
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              notchMargin: 6,
              color: Colors.indigo[900]!.withOpacity(0.85),
              child: const SizedBox(height: 50),
              shape: const CircularNotchedRectangle(),
            ),
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
      @required this.animationController2,
      this.wholeList})
      : super(key: key);
  AnimationController? animationController, animationController2;
  int? i;
  List? wholeList;
  @override
  State<BottomAppBarItem> createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<BottomAppBarItem> {
  @override
  Widget build(BuildContext context) {
    var animationProvider = Provider.of<AnimationProvider>(context);
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        var initialSleepData =
            Provider.of<InitialSleepData>(context, listen: false);
        await Hive.openBox('sleepdata');
        initialSleepData.backButtonPressed(true);
        animationProvider.setHeight(false);
        widget.animationController2!.reverse();
        await Future.delayed(const Duration(milliseconds: 125));
        widget.animationController!.reverse();
        await Future.delayed(const Duration(milliseconds: 850));
        animationProvider.displayAll();
        sleepDataProvider.secondScreen(false);
        sleepDataProvider.setInitialColor();
        sleepDataProvider.getNotesController.clear();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.indigo[900]!.withOpacity(0.85),
          onPressed: () async {
            var initialSleepData =
                Provider.of<InitialSleepData>(context, listen: false);
            if (widget.i == 0) {
              await Hive.openBox('sleepdata');
              initialSleepData.backButtonPressed(true);
              animationProvider.setHeight(false);
              widget.animationController2!.reverse();
              await Future.delayed(const Duration(milliseconds: 125));
              widget.animationController!.reverse();
              await Future.delayed(const Duration(milliseconds: 850));
              animationProvider.displayAll();
              sleepDataProvider.secondScreen(false);
              sleepDataProvider.setInitialColor();
              sleepDataProvider.getNotesController.clear();
            } else if (widget.i == 1) {
              SleepData sleepDataPlus =
                  SleepData(date: sleepDataProvider.getSleepDataList[0].date);
              sleepDataProvider.increaseSleepDataList(sleepData: sleepDataPlus);
            } else {
              await Hive.openBox('sleepdata');
              List<bool>? error = SleepInput.checkError(
                  sleepData: sleepDataProvider.getSleepDataList);
              if (error!.contains(true)) {
                for (int i = 0; i < error.length; i++) {
                  sleepDataProvider.setErrorColor(error);
                }
              } else {
                sleepDataProvider.setErrorColor(error);
                SleepInput.saveInputs(
                    sleepInput: sleepDataProvider.getSleepDataList);
                initialSleepData.saveButtonPressed(true);
                animationProvider.setHeight(false);
                widget.animationController2!.reverse();
                await Future.delayed(const Duration(milliseconds: 125));
                widget.animationController!.reverse();
                await Future.delayed(const Duration(milliseconds: 850));
                if (sleepDataProvider.getSleepDataList.length > 1) {
                  initialSleepData.moreThanOneInputChange(true);
                }
                animationProvider.displayAll();
                sleepDataProvider.secondScreen(false);
                sleepDataProvider.getNotesController.clear();
              }
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
      ),
    );
  }
}
