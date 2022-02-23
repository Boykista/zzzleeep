import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zzzleep/features/sharedpreferences.dart';
import 'package:zzzleep/models/sleepinput.dart';
import 'package:zzzleep/providers/animationprovider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';
import 'package:zzzleep/screens/listofdates.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SleepDataAdapter());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.indigo[900],
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await Future.delayed(const Duration(seconds: 1));
  await SimplePreferences.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) => SleepDataProvider()),
      ChangeNotifierProvider(
        create: (BuildContext context) => AnimationProvider(),
      ),
      ChangeNotifierProvider(
        create: (BuildContext context) => InitialSleepData(),
      ),
    ],
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.indigo[900],
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.indigo[900],
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white,
              selectionColor: Colors.white,
              selectionHandleColor: Colors.white),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          timePickerTheme: TimePickerThemeData(
              dialHandColor: Colors.indigo[900],
              backgroundColor: Colors.indigo[900]!.withOpacity(0.75),
              dialBackgroundColor: Colors.white,
              hourMinuteTextColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              helpTextStyle: const TextStyle(color: Colors.white),
              entryModeIconColor: Colors.white,
              hourMinuteColor: Colors.indigo[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              dayPeriodShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo[900]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              )),
        ),
        home: ListOfDates(),
      ),
    ),
  ));
}
