import 'package:cloud_firestore/cloud_firestore.dart';

class Entity {
  Entity(
      {required this.name,
      required this.image,
      required this.description,
      required this.address,
      required this.telephone,
      required this.mail,
      required this.link,
      required this.id});

  final String id;
  final String name;
  final String description;
  final String address;
  final String telephone;
  final String mail;
  final String link;
  final String image;

  factory Entity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('Document Data: $data'); // Debugging line

    return Entity(
        id: doc.id,
        name: data['name'] ?? 'Untitled Entity',
        description: data['description'] ?? '',
        address: (data['address'] ?? ''),
        telephone: data['telephone'] ?? '',
        mail: data['mail'] ?? '',
        link: data['link'] ?? '',
        image: data['image' ?? '']);
  }
  @override
  String toString() => name;
}
