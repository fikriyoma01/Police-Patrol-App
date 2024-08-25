import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/services/firebase_service.dart';

class IncidentManagementPage extends StatefulWidget {
  @override
  _IncidentManagementPageState createState() => _IncidentManagementPageState();
}

class _IncidentManagementPageState extends State<IncidentManagementPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Management'),
      ),
      body: StreamBuilder<List<Incident>>(
        stream: _firebaseService.getAllIncidents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          // List of incidents
          List<Incident> incidents = snapshot.data!;

          return ListView.builder(
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(incidents[index].description),
                subtitle: Text(
                    'Status: ${incidents[index].status}'), 
              );
            },
          );
        },
      ),
    );
  }
}
