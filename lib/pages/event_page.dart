import 'package:event_calendar/components/event/event_information.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../components/entity/entity_information.dart'; // Import the same widget used in EntityPage
import '../models/entity.dart';
import '../models/event.dart';
import '../services/entity_service.dart';
import '../services/event_service.dart';
import '../services/notification.dart';

class EventPage extends StatefulWidget {
  static String id = 'event_page';
  final String eventId;
  final String entityId;

  EventPage({required this.eventId, required this.entityId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited(); // Custom method to check if the event is in favorites
  }

  void _checkIfFavorited() async {
    // Check if the event is in the favorites
    _isFavorited = await _isEventInFavorites(widget.eventId);
    setState(() {}); // Update the state to reflect the correct color
  }

  Future<void> _addEventToFavorites(String eventId) async {
    try {
      final box = Hive.box<List<String>>('favorites');
      List<String> favoriteEventIds =
          box.get('events', defaultValue: <String>[])!;

      if (!favoriteEventIds.contains(eventId)) {
        favoriteEventIds.add(eventId);
        await box.put('events', favoriteEventIds);
      } else {
        print('Event already in favorites.');
      }
    } catch (e) {
      print('Error adding event to favorites: $e');
    }
  }

  Future<void> _removeEventFromFavorites(String eventId) async {
    // Implement removing the event from favorites
    try {
      final box = Hive.box<List<String>>('favorites');
      List<String> favoriteEventIds =
          box.get('events', defaultValue: <String>[])!;

      if (favoriteEventIds.contains(eventId)) {
        favoriteEventIds.remove(eventId);
        await box.put('events', favoriteEventIds);
      } else {
        print('Event not found in favorites.');
      }
    } catch (e) {
      print('Error removing event from favorites: $e');
    }
  }

  Future<bool> _isEventInFavorites(String eventId) async {
    // Implement checking if the event is in favorites
    try {
      final box = Hive.box<List<String>>('favorites');
      List<String> favoriteEventIds =
          box.get('events', defaultValue: <String>[])!;

      return favoriteEventIds.contains(eventId);
    } catch (e) {
      print('Error checking if event is in favorites: $e');
      return false; // Return false if there's an error
    }
  }

  void _scheduleEventNotification(DateTime eventDate) async {
    if (eventDate.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: 0, // Unique ID for the notification
        title: 'Reminder',
        body: 'The event starts in 1 hour!',
        scheduledDate: eventDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Event Details',
          style: TextStyle(
              fontSize: 26, color: Colors.white, fontFamily: 'Moderustic'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Event>(
        future: getEventDetails(widget.eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading event details.'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Event not found.'));
          } else {
            final event = snapshot.data!;
            return FutureBuilder<Entity>(
              future: getEntityDetails(widget.entityId),
              builder: (context, entitySnapshot) {
                if (entitySnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (entitySnapshot.hasError) {
                  return Center(child: Text('Error loading entity details.'));
                } else if (!entitySnapshot.hasData) {
                  return Center(child: Text('Entity not found.'));
                } else {
                  final entity = entitySnapshot.data!;
                  // Convert the Timestamp to DateTime
                  final DateTime eventDate = event.date.toDate();
                  // Format the date to a readable format
                  final String formattedDate =
                      DateFormat('MMMM dd, yyyy – h:mm a').format(eventDate);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Event Image
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  color: Colors.grey.shade300,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: event.image.isNotEmpty
                                      ? Image.network(
                                          event.image,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.event,
                                              size: 100,
                                              color: Colors.grey.shade800,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.event,
                                          size: 100,
                                          color: Colors.grey.shade800,
                                        ),
                                ),
                              ),
                              // Event Name and Description
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        event.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Moderustic'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        event.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontFamily: 'Moderustic',
                                              fontSize: 18,
                                              color: const Color.fromARGB(
                                                  255, 143, 147, 149),
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Event Information Section
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          child: EventInformation(
                              event: event,
                              icon: Icons.date_range,
                              text: formattedDate,
                              url: ''),
                        ),

                        const SizedBox(height: 20),

                        if (event.address.isNotEmpty)
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            child: EventInformation(
                                event: event,
                                icon: Icons.location_on,
                                text: event.address,
                                url:
                                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(event.address)}'),
                          ),

                        const SizedBox(height: 20),

                        if (entity.telephone.isNotEmpty)
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            child: EntityInformation(
                                entity: entity,
                                icon: Icons.phone_outlined,
                                text: entity.telephone,
                                url: 'tel:${entity.telephone}'),
                          ),
                        const SizedBox(height: 20),

                        if (entity.link.isNotEmpty)
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            child: EntityInformation(
                                entity: entity,
                                icon: Icons.link,
                                text: entity.link,
                                url: 'https://${entity.link}'),
                          ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () async {
            if (_isFavorited) {
              await _removeEventFromFavorites(widget.eventId);
            } else {
              await _addEventToFavorites(widget.eventId);
            }
            setState(() {
              _isFavorited = !_isFavorited;
            });
          },
          hoverColor: Colors.lightBlueAccent,
          backgroundColor: _isFavorited ? Colors.lightBlueAccent : Colors.white,
          child: Icon(
            _isFavorited ? Icons.favorite : Icons.favorite_border,
            color: _isFavorited ? Colors.white : Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}
