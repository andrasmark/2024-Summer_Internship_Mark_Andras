import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../pages/event_page.dart';
import '../../services/notification.dart';

class EventCard extends StatelessWidget {
  EventCard({required this.event, required this.color});

  final Event event;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          event.name.isNotEmpty ? event.name : 'No Title Available',
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontFamily: 'Moderustic',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EventPage(eventId: event.id, entityId: event.entityId),
            ),
          );
        },
      ),
    );
  }
}

class EventCardWithNotification extends StatelessWidget {
  EventCardWithNotification({required this.event, required this.color});

  final Event event;
  final Color? color;

  Future<void> _scheduleNotification() async {
    final notificationService = NotificationService();

    // Fetch the event date and time
    final eventDateTime =
        event.date.toDate(); // Assuming event.date is a Timestamp

    // Schedule the notification 1 hour before the event
    await notificationService.scheduleNotification(
      id: event.id.hashCode, // Use a unique ID for each event
      title: 'Reminder for ${event.name}',
      body: 'The event "${event.name}" is starting in 1 hour!',
      scheduledDate: eventDateTime,
    );

    print('Notification scheduled for ${event.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          event.name.isNotEmpty ? event.name : 'No Title Available',
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontFamily: 'Moderustic',
        ),
        trailing: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () async {
            NotificationService().showNotification(
              title: 'Notification',
              body: 'Set a notification for ${event.name}',
              id: 0,
            );
            await _scheduleNotification();
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EventPage(eventId: event.id, entityId: event.entityId),
            ),
          );
        },
      ),
    );
  }
}
