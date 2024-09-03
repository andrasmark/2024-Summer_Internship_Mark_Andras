import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/entity.dart';

Future<List<Entity>> getEntities() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('entities').get();
  return snapshot.docs.map((doc) => Entity.fromFirestore(doc)).toList();
}

Future<Entity> getEntityDetails(String entityId) async {
  final doc = await FirebaseFirestore.instance
      .collection('entities')
      .doc(entityId)
      .get();
  return Entity.fromFirestore(doc);
}
