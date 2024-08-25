import 'package:flutter/material.dart';
import 'package:police_patrol_app/services/auth_service.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/models/patrol_route.dart';
import 'package:police_patrol_app/views/route_detail_page.dart';
import 'package:police_patrol_app/models/incident.dart';

class ReportViewPage extends StatefulWidget {
  @override
  _ReportViewPageState createState() => _ReportViewPageState();
}

class _ReportViewPageState extends State<ReportViewPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<PatrolRoute> _patrolRoutes = [];
  Map<String, List<Incident>> _routeIncidents = {};

  @override
  void initState() {
    super.initState();

    // Fetching patrol routes on initialization
    _firebaseService
        .getPatrolRoutesForOfficer(AuthService().currentUser!.uid)
        .listen((routes) async {
      // Sort routes based on startTime in descending order
      routes.sort((a, b) => b.startTime.compareTo(a.startTime));
      setState(() {
        _patrolRoutes = routes;
      });

      for (var route in _patrolRoutes) {
        var incidents =
            await _firebaseService.getIncidentsForPatrolRoute(route.id);
        setState(() {
          _routeIncidents[route.id] = incidents;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Patrol Route Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _patrolRoutes.length,
          itemBuilder: (context, index) {
            PatrolRoute route = _patrolRoutes[index];
            Duration patrolDuration =
                route.endTime!.difference(route.startTime);
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  child: Icon(Icons.map, color: Colors.white),
                  backgroundColor: Colors.blue,
                ),
                title: Text(
                  'Patrol on ${route.startTime.toLocal()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End: ${route.endTime!.toLocal()} | Duration: ${patrolDuration.inMinutes} mins',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Incidents: ${_routeIncidents[route.id]?.length ?? 0}',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RouteDetailPage(patrolRoute: _patrolRoutes[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
