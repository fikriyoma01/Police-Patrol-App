import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/utils/constants.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onTap;

  IncidentCard({
    required this.incident,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: DEFAULT_PADDING / 2, horizontal: DEFAULT_PADDING),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          incident.type ?? "Incident",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.0),
            Text(incident.description),
            SizedBox(height: 10.0),
            Text(
              'Reported on: ${incident.timestamp.toLocal().toIso8601String()}',
              style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
      ),
    );
  }
}
