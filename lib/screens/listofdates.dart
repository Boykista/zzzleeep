import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/functions/sleepconverter.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/parts/sleepfields.dart';
import 'package:zzzleep/providers/animationprovider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';
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
              child: Column(
                children: [
                  SleepDates(indigo: indigo, fontSize: fontSize),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (value) {
          print('AAAAAAAAAABBBBBBB');
          Hive.box('sleepdata').delete('2022-02-13');
        },
        buttonBackgroundColor: Colors.white,
        color: indigo!.withOpacity(0.58),
        backgroundColor: Colors.transparent,
        height: 60,
        items: [
          FaIcon(
            FontAwesomeIcons.chartLine,
            color: Colors.indigo[900],
            size: 30,
          )
          // Icon(
          //   Icons.stacked_line_chart,
          //   color: Colors.indigo[900],
          //   size: 30,
          // )
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
  AnimationController? _animationController2;
  Animation<double>? scale2;
  @override
  void initState() {
    _animationController2 = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: Duration(seconds: 1));
    scale2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController2!, curve: Curves.easeOutExpo));
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
    double screenHeight = MediaQuery.of(context).size.height;
    var animationProvider =
        Provider.of<AnimationProvider>(context, listen: false);
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
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              final sleepData = data.getAt(i) as List;
                              var sleepInputList =
                                  List<SleepData>.from(sleepData);
                              print(
                                  'LENGTH POJEDINACNOG SLEEP INPUTA $sleepInputList: ${sleepInputList.length}');
                              SleepData sleepInput =
                                  SleepData(date: sleepData[0].date);

                              if (sleepInputList.length > 1) {
                                moreThanOneInput = true;
                                sleepInput = SleepInput.hoursMinutesConverter(
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
                                delay:
                                    Duration(seconds: i < data.length ? 0 : i),
                                slidingCurve: Curves.bounceOut,
                                child: Dates(
                                  indigo: indigo,
                                  fontSize: fontSize,
                                  sleepInput: sleepInput,
                                  sleepInputList: sleepInputList,
                                  i: i,
                                  date: date,
                                  animationController2: _animationController2,
                                  scale2: scale2,
                                ),
                              );
                            },
                            itemCount: data.length,
                          ),
                        ),
                        LimitedBox(
                          maxHeight: screenHeight - 100,
                          maxWidth: screenWidth,
                          child: ScaleTransition(
                            scale: scale2!,
                            child: SetSleepTime(),
                          ),
                        )
                      ],
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
  Dates(
      {Key? key,
      @required this.indigo,
      @required this.fontSize,
      @required this.sleepInput,
      @required this.sleepInputList,
      @required this.i,
      @required this.date,
      @required this.animationController2,
      @required this.scale2})
      : super(key: key);

  Color? indigo;
  double? fontSize;
  SleepData? sleepInput;
  List<SleepData>? sleepInputList;
  int? i;
  String? date;
  int? millisecondsDelay;
  AnimationController? animationController2;
  Animation<double>? scale2;

  @override
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> with TickerProviderStateMixin {
  AnimationController? _animationController; //, _animationController2;
  Animation<double>? scale; //, scale2;
  @override
  void initState() {
    _animationController = AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: Duration(seconds: 1));
    scale = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeOutExpo));

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var animationProvider = Provider.of<AnimationProvider>(context);
    print('WWWWWWWWWWWWWWWWW ${scale!.value * screenWidth}');
    return AnimatedBuilder(
      animation: _animationController!,
      builder: ((BuildContext context, Widget? child) => Opacity(
            opacity: animationProvider.getOpacity[widget.i!],
            child: ScaleTransition(
              scale: scale!,
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
                          var sleepDataProvider =
                              Provider.of<SleepDataProvider>(context,
                                  listen: false);
                          sleepDataProvider.setSleepDataList(
                              sleepData: widget.sleepInputList);
                          sleepDataProvider.setNotes(
                              notes: widget.sleepInputList![0].notes);
                          await Future.delayed(Duration(milliseconds: 300));
                          animationProvider.displayOne(widget.i!);
                          await Future.delayed(Duration(milliseconds: 300));
                          _animationController!.forward();
                          await Future.delayed(Duration(milliseconds: 1000));
                          widget.animationController2!.forward();
                          // Navigator.pushNamed(context, '/settime',
                          //     arguments: widget.sleepInputList);
                          // Navigator.push(
                          //   context,
                          //   _createRoute(),
                          // );
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

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 2),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SetSleepTime(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
