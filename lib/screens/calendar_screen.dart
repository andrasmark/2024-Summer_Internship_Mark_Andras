import 'package:event_calendar/models/event.dart';
import 'package:event_calendar/pages/favourites_page.dart';
import 'package:event_calendar/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/event/event_card.dart';
import '../services/event_service.dart';
import 'entities_list_screen.dart';

class CalendarScreen extends StatefulWidget {
  static String id = 'calendar_screen';

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<Map<DateTime, List<Event>>> _events;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = ValueNotifier({});
    loadAllEvents();
  }

  Future<void> loadAllEvents() async {
    final events = await getAllEvents();
    final eventsByDate = <DateTime, List<Event>>{};
    for (var event in events) {
      final eventDate = event.date.toDate();
      final date = DateTime(eventDate.year, eventDate.month, eventDate.day);
      if (!eventsByDate.containsKey(date)) {
        eventsByDate[date] = [];
      }
      eventsByDate[date]!.add(event);
    }
    _events.value = eventsByDate;
  }

  List<Event> _getEventsForDate(DateTime date) {
    final eventsByDate = _events.value;
    final key = DateTime(date.year, date.month, date.day);
    return eventsByDate[key] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      // _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, CalendarScreen.id);
          break;
        case 1:
          Navigator.pushNamed(context, EntitiesListScreen.id);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontFamily: 'Moderustic',
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouritesPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TableCalendar<Event>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            eventLoader: (day) => _getEventsForDate(day),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            pageAnimationEnabled: true,
          ),
          SizedBox(height: 10),
          // List for Events
          Expanded(
            child: ValueListenableBuilder<Map<DateTime, List<Event>>>(
              valueListenable: _events,
              builder: (context, eventsByDate, _) {
                final events =
                    _getEventsForDate(_selectedDay ?? DateTime.now());
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCardWithNotification(
                      event: event,
                      color: Colors.blue[300],
                    );
                  },
                );
              },
            ),
          ),
          // Footer
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Expanded(
          //         child: PageButton(label: 'Events', route: EventPage.id),
          //       ),
          //       SizedBox(width: 4),
          //       Expanded(
          //         child: PageButton(
          //             label: 'Entities', route: EntitiesListScreen.id),
          //       ),
          //     ],
          //   ),
          // ),
        ],
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

class PageButton extends StatelessWidget {
  PageButton({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontFamily: 'Moderustic'),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 20.0)),
      ),
    );
  }
}
