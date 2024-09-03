import 'package:event_calendar/components/event/event_data_icon_and_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/event.dart';

class EventInformation extends StatelessWidget {
  const EventInformation(
      {super.key,
      required this.event,
      required this.icon,
      required this.text,
      required this.url});

  final Event event;
  final IconData icon;
  final String text;
  final String url;

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          _launchURL(url);
        },
        //
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EventDataIconAndText(icon: icon, text: text),
        ),
      ),
    );
  }
}
