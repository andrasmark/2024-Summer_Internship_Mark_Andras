import 'package:event_calendar/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/event.dart';
import 'event_page.dart';

class FavouritesPage extends StatefulWidget {
  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<String> _favoriteEventIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final box = Hive.box<List<String>>('favorites');
      List<String>? favoriteEventIds = box.get('events');
      print('Favorite Event IDs: $favoriteEventIds');
      setState(() {
        _favoriteEventIds = favoriteEventIds ?? [];
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _removeFromFavorites(String eventId) async {
    final box = Hive.box<List<String>>('favorites');
    List<String> favoriteEventIds =
        box.get('events', defaultValue: <String>[])!;
    favoriteEventIds.remove(eventId);
    await box.put('events', favoriteEventIds);

    // Refresh the list
    setState(() {
      _favoriteEventIds = favoriteEventIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _favoriteEventIds.length,
          itemBuilder: (context, index) {
            final eventId = _favoriteEventIds[index];
            return FutureBuilder<Event>(
              future: getEventDetails(eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error loading event'),
                  );
                } else if (!snapshot.hasData) {
                  return ListTile(
                    title: Text('Event not found'),
                  );
                } else {
                  final event = snapshot.data!;
                  return Card(
                    color: Colors.blueAccent,
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        event.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Moderustic',
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeFromFavorites(eventId);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventPage(
                              eventId: event.id,
                              entityId: event.entityId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
