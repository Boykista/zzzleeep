import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/providers/animationprovider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';
import 'package:zzzleep/screens/listofdates.dart';
import 'package:zzzleep/screens/settime.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SleepDataAdapter());
  //await Hive.openBox('sleepdata');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) => SleepDataProvider()),
      ChangeNotifierProvider(
          create: (BuildContext context) => AnimationProvider()),
    ],
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.white,
            selectionHandleColor: Colors.white),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            // textStyle: MaterialStateProperty.all<TextStyle>(
            //     TextStyle(color: Colors.indigo)),
            // backgroundColor: MaterialStateProperty.all<Color>(
            //     Color.fromARGB(255, 95, 60, 146)),
            // overlayColor: MaterialStateProperty.all<Color>(
            //   Color.fromARGB(255, 95, 85, 146),
            // ),
            // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //   RoundedRectangleBorder(),
            // ),
            // side: MaterialStateProperty.all<BorderSide>(BorderSide(
            //   color: Colors.indigo[900]!,
            //   width: 3,
            // ))
          ),
        ),
        timePickerTheme: TimePickerThemeData(
            dialHandColor: Colors.indigo[900],
            backgroundColor: Colors.indigo[900]!.withOpacity(0.75),
            dialBackgroundColor: Colors.white,
            hourMinuteTextColor: Colors.white,
            hourMinuteShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            helpTextStyle: TextStyle(color: Colors.white),
            entryModeIconColor: Colors.white,
            hourMinuteColor: Colors.indigo[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            dayPeriodShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo[900]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              // filled: true,
              // fillColor: Colors.white,
              // focusColor: Colors.white,
              // counterStyle: TextStyle(color: Colors.white)
            )),
      ),
      routes: {
        '/listofdates': (BuildContext context) => ListOfDates(),
        '/settime': (BuildContext context) => SetSleepTime(),
      },
      initialRoute: '/listofdates',
    ),
  ));
}
