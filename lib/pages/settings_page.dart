import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsConsent = false;
  bool _calendarConsent = false;

  // The Timer periodically checks the notification permission status.
  // If the permission status changes (e.g., if the user manually toggles it in the phone’s settings),
  // it updates the app’s setting to reflect this change.
  Timer? _permissionCheckTimer;

  @override
  void initState() {
    super.initState();
    _loadConsents();
    _startPermissionCheckTimer();
  }

  void _startPermissionCheckTimer() {
    // Check permission status every 10 seconds
    _permissionCheckTimer =
        Timer.periodic(Duration(seconds: 10), (timer) async {
      PermissionStatus status = await Permission.notification.status;
      setState(() {
        _notificationsConsent = status.isGranted;
      });
      // Save to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsConsent', _notificationsConsent);
    });
  }

  @override
  void dispose() {
    _permissionCheckTimer?.cancel();
    super.dispose();
  }

  void _loadConsents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsConsent = prefs.getBool('notificationsConsent') ?? false;
      _calendarConsent = prefs.getBool('calendarConsent') ?? false;
    });
  }

  void _saveConsents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsConsent', _notificationsConsent);
    await prefs.setBool('calendarConsent', _calendarConsent);

    if (_notificationsConsent) {
      // Request notification permissions
      await Permission.notification.request();
    }

    // Notify the user that settings have been updated
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings updated successfullyyy'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Manage your consents:"),
            SwitchListTile(
              title: Text("Notifications"),
              value: _notificationsConsent,
              onChanged: (bool value) {
                setState(() {
                  _notificationsConsent = value;
                });
                _saveConsents();
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.lightBlueAccent,
            ),
            SwitchListTile(
              title: Text("Calendar Access"),
              value: _calendarConsent,
              onChanged: (bool value) {
                setState(() {
                  _calendarConsent = value;
                });
                _saveConsents();
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
