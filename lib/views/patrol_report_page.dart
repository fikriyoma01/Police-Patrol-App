import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/patrol_report.dart';
import 'package:police_patrol_app/services/auth_service.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:uuid/uuid.dart';

class PatrolReportPage extends StatefulWidget {
  final Function onReportSubmitted;
  final String? patrolRouteId;

  PatrolReportPage({
    required this.onReportSubmitted,
    this.patrolRouteId,
  });

  @override
  _PatrolReportPageState createState() => _PatrolReportPageState();
}

class _PatrolReportPageState extends State<PatrolReportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _warrantDateTimeController =
      TextEditingController();
  final TextEditingController _typeOfPatrolController = TextEditingController();
  final TextEditingController _natureOfPatrolController =
      TextEditingController();
  final TextEditingController _numberOfPersonnelController =
      TextEditingController();

  int _numberOfPersonnel = 1; // For slider
  bool _isFootPatrol = false; // For switch
  String _typeOfPatrol = 'Foot Patrol'; // For radio buttons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patrol Report')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _warrantDateTimeController,
                decoration: InputDecoration(
                  labelText: 'Tanggal dan Waktu Surat Perintah',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    DateTime finalDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      time?.hour ?? 0,
                      time?.minute ?? 0,
                    );
                    _warrantDateTimeController.text =
                        finalDateTime.toLocal().toString();
                  }
                },
              ),
              SizedBox(height: 15),
              Text('Type of Patrol:', style: TextStyle(fontSize: 16)),
              Column(
                children: [
                  ListTile(
                    title: const Text('Patroli Wilayah'),
                    leading: Radio<String>(
                      value: 'Patroli Wilayah',
                      groupValue: _typeOfPatrol,
                      onChanged: (String? value) {
                        setState(() {
                          _typeOfPatrol = value!;
                          _typeOfPatrolController.text = _typeOfPatrol;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Patroli Terpadu'),
                    leading: Radio<String>(
                      value: 'Patroli Terpadu',
                      groupValue: _typeOfPatrol,
                      onChanged: (String? value) {
                        setState(() {
                          _typeOfPatrol = value!;
                          _typeOfPatrolController.text = _typeOfPatrol;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Patroli Rutin'),
                    leading: Radio<String>(
                      value: 'Patroli Rutin',
                      groupValue: _typeOfPatrol,
                      onChanged: (String? value) {
                        setState(() {
                          _typeOfPatrol = value!;
                          _typeOfPatrolController.text = _typeOfPatrol;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _natureOfPatrolController,
                decoration: InputDecoration(
                  labelText: 'Sifat Patroli',
                  border: OutlineInputBorder(),
                ),
              ),
              SwitchListTile(
                title: Text("Patrol on Foot?"),
                value: _isFootPatrol,
                onChanged: (bool value) {
                  setState(() {
                    _isFootPatrol = value;
                  });
                },
              ),
              SizedBox(height: 15),
              Text('Number of Personnel:', style: TextStyle(fontSize: 16)),
              Slider(
                value: _numberOfPersonnel.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: _numberOfPersonnel.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _numberOfPersonnel = value.round();
                    _numberOfPersonnelController.text =
                        _numberOfPersonnel.toString();
                  });
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DateTime? warrantDateTime;
                    try {
                      warrantDateTime =
                          DateTime.parse(_warrantDateTimeController.text);
                    } catch (e) {
                      print("Could not parse DateTime: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid Date-Time format')),
                      );
                      return;
                    }
                    // Create PatrolReport object
                    PatrolReport report = PatrolReport(
                      id: Uuid().v1(), // Generate a new unique ID
                      officerId: AuthService()
                          .currentUser!
                          .uid, // Get the current officer ID

                      warrantDateTime:
                          warrantDateTime, // Use the parsed DateTime
                      typeOfPatrol: _typeOfPatrol,
                      natureOfPatrol: _natureOfPatrolController.text,
                      isFootPatrol: _isFootPatrol,
                      numberOfPersonnel: _numberOfPersonnel,
                      patrolRouteId: widget.patrolRouteId ?? '',
                    );

                    // Save to Firebase
                    FirebaseService().addPatrolReport(report).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patrol Report Submitted!')),
                      );
                      widget.onReportSubmitted();

                      // Navigate back to the previous page
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to submit report: $error')),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields.')),
                    );
                  }
                },
                child: Text('Submit Patrol Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
