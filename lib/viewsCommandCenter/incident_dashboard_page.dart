import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/viewsCommandCenter/incident_details_page.dart';

class IncidentDashboardPage extends StatefulWidget {
  @override
  _IncidentDashboardPageState createState() => _IncidentDashboardPageState();
}

class _IncidentDashboardPageState extends State<IncidentDashboardPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  IncidentStatus? selectedStatus = null; 
  List<IncidentStatus> statuses = IncidentStatus.values;
  List<String> statusOptions = ["All"] +
      IncidentStatus.values.map((e) => e.toString().split('.').last).toList();

  @override
  Widget build(BuildContext context) {
    print(
        "Type of selectedStatus: ${selectedStatus.runtimeType}"); 
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Trigger a rebuild to refresh the list
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedStatus?.toString().split('.').last ?? "All",
                items: statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == "All") {
                      selectedStatus = null;
                    } else {
                      selectedStatus = IncidentStatus.values.firstWhere(
                          (e) => e.toString().split('.').last == newValue);
                    }
                  });
                },
              )),
          Expanded(
            child: StreamBuilder(
              stream: selectedStatus == null
                  ? _db
                      .collection('incidents')
                      .orderBy('timestamp', descending: true)
                      .snapshots()
                  : _db
                      .collection('incidents')
                      .where('status', isEqualTo: selectedStatus?.index)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  print(
                      "Snapshot data: ${snapshot.data!.docs.map((doc) => doc.data())}");
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    try {
                      Incident incident = Incident.fromJson(
                          document.data() as Map<String, dynamic>);
                      return Card(
                        margin: EdgeInsets.all(8),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: getColorBasedOnStatus(
                                incident.status as IncidentStatus?),
                            child: getIconBasedOnStatus(
                                incident.status as IncidentStatus?),
                          ),
                          title: Text(incident.description),
                          subtitle: Text(incident.timestamp.toString()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IncidentDetailsPage(incident: incident),
                              ),
                            );
                          },
                        ),
                      );
                    } catch (e) {
                      print("Error while converting document to Incident: $e");
                      return SizedBox.shrink();
                    }
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color getColorBasedOnStatus(IncidentStatus? status) {
    switch (status) {
      case IncidentStatus.Pending:
        return Colors.red;
      case IncidentStatus.Resolved:
        return Colors.green;
      case IncidentStatus.InProgress:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Icon getIconBasedOnStatus(IncidentStatus? status) {
    switch (status) {
      case IncidentStatus.Pending:
        return Icon(Icons.pending);
      case IncidentStatus.Resolved:
        return Icon(Icons.check_circle);
      case IncidentStatus.InProgress:
        return Icon(Icons.sync);
      default:
        return Icon(Icons.info);
    }
  }
}
