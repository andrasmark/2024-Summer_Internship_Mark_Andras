import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_calendar/services/entity_service.dart';
import 'package:flutter/material.dart';

import '../components/entity/entity_information.dart';
import '../components/event/event_card.dart';
import '../models/entity.dart';
import '../models/event.dart';

class EntityPage extends StatelessWidget {
  static String id = 'entity_page';
  final String entityId;

  EntityPage({required this.entityId});

  Future<List<Event>> _getEventsForEntity(String entityId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('entityId', isEqualTo: entityId)
        .get();

    print('Fetched ${snapshot.docs.length} events for entityId: $entityId');

    return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Entity details',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Entity>(
          future: getEntityDetails(entityId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading entity details.'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Entity not found.'));
            } else {
              final entity = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                      child: entity.image.isNotEmpty
                                          ? Image.network(
                                              entity.image,
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  size: 100,
                                                  color: Colors.grey.shade800,
                                                );
                                              },
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 100,
                                              color: Colors.grey.shade800,
                                            ),
                                    ),
                                  ),
                                  // Displaying Entity name, description
                                  if (entity.name.isNotEmpty ||
                                      entity.description.isNotEmpty)
                                    Ink(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            //Entity name
                                            Center(
                                              child: Text(
                                                entity.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),

                                            // Description
                                            Center(
                                              child: Text(
                                                entity.description,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontSize: 18,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              143,
                                                              147,
                                                              149),
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  //Mail
                                  if (entity.mail.isNotEmpty)
                                    EntityInformation(
                                        entity: entity,
                                        icon: Icons.mail,
                                        text: entity.mail,
                                        url: 'mail:${entity.mail}'),
                                  const SizedBox(height: 20),
                                  // Phone
                                  if (entity.telephone.isNotEmpty)
                                    EntityInformation(
                                        entity: entity,
                                        icon: Icons.phone_outlined,
                                        text: entity.telephone,
                                        url: 'tel:${entity.telephone}'),
                                  const SizedBox(height: 20),

                                  // Address
                                  if (entity.address.isNotEmpty)
                                    EntityInformation(
                                        entity: entity,
                                        icon: Icons.location_on,
                                        text: entity.address,
                                        url:
                                            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(entity.address)}'),
                                  const SizedBox(height: 20),

                                  // Website
                                  if (entity.link.isNotEmpty)
                                    EntityInformation(
                                        entity: entity,
                                        icon: Icons.public,
                                        text: entity.link,
                                        url: 'mailto:${entity.mail}'),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder<List<Event>>(
                            future: _getEventsForEntity(entityId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                print('Error: ${snapshot.error}');
                                return Center(
                                    child: Text('Error loading events.'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                print(
                                    'No events found for entityId: $entityId');
                                return Center(child: Text('No events found.'));
                              } else {
                                final events = snapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];
                                    return EventCard(
                                        event: event, color: Colors.blueAccent);
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
