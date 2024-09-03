import 'package:event_calendar/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/consent_page.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConsentGiven = prefs.getBool('consentGiven') ?? false;
    print('szoa');
    await Future.delayed(Duration(seconds: 2));

    if (isConsentGiven) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConsentPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Image.asset(
            'images/logo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
