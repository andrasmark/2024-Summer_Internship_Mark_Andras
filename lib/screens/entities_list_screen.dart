import 'package:event_calendar/services/entity_service.dart';
import 'package:flutter/material.dart';

import '../components/entity/entity_card.dart';
import '../models/entity.dart';
import 'calendar_screen.dart';

class EntitiesListScreen extends StatefulWidget {
  static String id = 'entities_list_screen';

  @override
  State<EntitiesListScreen> createState() => _EntitiesListScreenState();
}

class _EntitiesListScreenState extends State<EntitiesListScreen> {
  int _selectedIndex = 1;

  void _onNavBarItemTapped(int index) {
    setState(() {
      // _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, CalendarScreen.id);
          break;
        case 1:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entities'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Entity>>(
          future: getEntities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading entities.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No entities found.'));
            } else {
              final entities = snapshot.data!;
              return ListView.builder(
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  final entity = entities[index];
                  return EntityCard(entity: entity);
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
              size: 30,
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 30,
            ),
            label: 'Entities',
          ),
        ],
      ),
    );
  }
}
