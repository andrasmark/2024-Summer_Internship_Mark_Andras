import 'package:flutter/material.dart';

import '../../models/entity.dart';
import '../../pages/entity_page.dart';

class EntityCard extends StatelessWidget {
  EntityCard({required this.entity});

  final Entity entity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          entity.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Moderustic',
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityPage(entityId: entity.id),
            ),
          );
        },
      ),
    );
  }
}
