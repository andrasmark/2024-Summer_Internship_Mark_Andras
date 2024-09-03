import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/entity.dart';
import 'entity_data_icon_and_text.dart';

class EntityInformation extends StatelessWidget {
  const EntityInformation(
      {super.key,
      required this.entity,
      required this.icon,
      required this.text,
      required this.url});

  final Entity entity;
  final IconData icon;
  final String text;
  final String url;

  Future<void> _launchURL(String url) async {
    Uri uri;
    if (url.startsWith('http') || url.startsWith('https')) {
      // Handle web URLs
      uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
    } else if (url.startsWith('tel:') || url.startsWith('mailto:')) {
      // Handle phone or email URLs
      uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // Default to http if no scheme is provided
      uri = Uri.parse('https://$url');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
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
          child: EntityDataIconAndText(icon: icon, text: text),
        ),
      ),
    );
  }
}
