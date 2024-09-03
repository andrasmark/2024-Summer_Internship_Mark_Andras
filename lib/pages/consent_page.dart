import 'package:event_calendar/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentPage extends StatefulWidget {
  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _notificationsConsent = false;
  bool _calendarConsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consent Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Please give your consent for the following:"),
            SwitchListTile(
              title: Text("Notifications"),
              value: _notificationsConsent,
              onChanged: (bool value) async {
                setState(() {
                  _notificationsConsent = value;
                });
                if (value) {
                  await Permission.notification.request();
                }
              },
            ),
            SwitchListTile(
              title: Text("Calendar Access"),
              value: _calendarConsent,
              onChanged: (bool value) {
                setState(() {
                  _calendarConsent = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveConsents,
              child: Text("Save and Continue"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveConsents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsConsent', _notificationsConsent);
    await prefs.setBool('calendarConsent', _calendarConsent);
    await prefs.setBool('consentGiven', true); // Mark the app as used

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CalendarScreen()),
    );
  }
}
