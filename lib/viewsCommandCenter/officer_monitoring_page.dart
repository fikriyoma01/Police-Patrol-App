import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/user.dart';
import 'package:police_patrol_app/services/firebase_service.dart';

class OfficerMonitoringPage extends StatefulWidget {
  @override
  _OfficerMonitoringPageState createState() => _OfficerMonitoringPageState();
}

class _OfficerMonitoringPageState extends State<OfficerMonitoringPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Officer Monitoring'),
      ),
      body: StreamBuilder<List<User>>(
        stream: _firebaseService.getOfficer(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          // List of officers
          List<User> officers = snapshot.data!;

          return ListView.builder(
            itemCount: officers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(officers[index].name ?? 'Unknown'),
              );
            },
          );
        },
      ),
    );
  }
}
