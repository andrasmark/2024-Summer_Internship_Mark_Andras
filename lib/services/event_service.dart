import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';

late final ValueNotifier<Map<DateTime, List<Event>>> events;

Future<Event> getEventDetails(String eventId) async {
  final doc =
      await FirebaseFirestore.instance.collection('events').doc(eventId).get();
  return Event.fromFirestore(doc);
}

Future<List<Event>> getAllEvents() async {
  final snapshot = await FirebaseFirestore.instance.collection('events').get();
  return snapshot.docs.map((doc) {
    final event = Event.fromFirestore(doc);
    print('Event fetched: ${event.name}'); // Debugging line
    return event;
  }).toList();
}
