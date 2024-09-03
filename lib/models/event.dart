import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event({
    required this.name,
    required this.description,
    required this.address,
    required this.date,
    required this.image,
    required this.id,
    required this.entityId,
  });

  final String name;
  final String description;
  final String address;
  final Timestamp date;
  final String image;
  final String id;
  final String entityId;

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('Document Data: $data'); // Debugging line

    return Event(
        id: doc.id,
        name: data['name'] ?? 'Untitled Event',
        description: data['description'] ?? '',
        address: (data['address'] ?? ''),
        date: (data['date'] as Timestamp),
        image: data['image' ?? ''],
        entityId: data['entityId'] ?? '');
  }
  @override
  String toString() => name;
}
