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
      routes: {
        '/listofdates': (BuildContext context) => ListOfDates(),
        '/settime': (BuildContext context) => SetSleepTime(),
      },
      initialRoute: '/listofdates',
    ),
  ));
}
