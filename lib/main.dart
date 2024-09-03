import 'package:event_calendar/screens/calendar_screen.dart';
import 'package:event_calendar/screens/entities_list_screen.dart';
import 'package:event_calendar/screens/splash_screen.dart';
import 'package:event_calendar/services/notification.dart';
import 'package:event_calendar/services/timezone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox<List<String>>('favorites');

  initializeTimeZones();

  NotificationService().initNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SplashScreen(),
      routes: {
        CalendarScreen.id: (context) => CalendarScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        EntitiesListScreen.id: (context) => EntitiesListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
