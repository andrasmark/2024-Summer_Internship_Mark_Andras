import 'package:flutter/material.dart';

class EventDataIconAndText extends StatelessWidget {
  final IconData icon;
  final String text;

  EventDataIconAndText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.lightBlueAccent,
          size: 30,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Moderustic',
            ),
          ),
        )
      ],
    );
  }
}
