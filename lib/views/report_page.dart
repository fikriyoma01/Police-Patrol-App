import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/services/location_service.dart';
import 'package:police_patrol_app/utils/constants.dart';
import 'package:police_patrol_app/widgets/custom_button.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class ReportPage extends StatefulWidget {
  final String? patrolRouteId; // The ID of the current patrol route

  ReportPage({required this.patrolRouteId});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final LocationService _locationService = LocationService();
  File? _selectedMedia;
  String? _mediaType; 
  String _incidentStatus = 'Pending'; // Default status, can be modified

  Future<void> _pickMedia(
      BuildContext context, bool isCamera, bool isImage) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? media = isImage
        ? await _picker.pickImage(
            source: isCamera ? ImageSource.camera : ImageSource.gallery)
        : await _picker.pickVideo(
            source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (media != null) {
      setState(() {
        _selectedMedia = File(media.path);
        _mediaType = isImage ? 'image' : 'video';
      });
    }
  }

  Future<String?> _uploadMedia(File media, String mediaType) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child("incidents/${Uuid().v1()}.$mediaType");
      UploadTask uploadTask = ref.putFile(media);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  final TextEditingController _descriptionController = TextEditingController();
  String _incidentType = 'Theft'; // Default type, can be modified
  String _errorMessage = '';

  void _addIncident(Incident incident) {
    // Associate the incident with the provided patrolRouteId
    Incident newIncident = Incident(
      id: incident.id,
      latitude: incident.latitude,
      longitude: incident.longitude,
      description: incident.description,
      timestamp: incident.timestamp,
      reportedBy: incident.reportedBy,
      type: incident.type,
      mediaUrl: incident.mediaUrl,
      mediaType: incident.mediaType,
      patrolRouteId: widget.patrolRouteId,
      status: IncidentStatus.Pending, 
    );

    _firebaseService.addIncident(newIncident);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Incident')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Incident Type:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              isExpanded: true,
              value: _incidentType,
              onChanged: (String? newValue) {
                setState(() {
                  _incidentType = newValue!;
                });
              },
              items: <String>['Theft', 'Assault', 'Accident', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickMedia(context, true, true),
                  icon: Icon(Icons.camera),
                  label: Text('Capture Photo'),
                ),
                // ElevatedButton.icon(
                //   onPressed: () => _pickMedia(context, true, false),
                //   icon: Icon(Icons.videocam),
                //   label: Text('Capture Video'),
                // ),
              ],
            ),
            SizedBox(height: 15),
            if (_selectedMedia != null)
              Card(
                elevation: 4,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.file(
                  _selectedMedia!,
                  fit: BoxFit.cover,
                  height: 325,
                ),
              ),
            Text('Incident Status:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              isExpanded: true,
              value: _incidentStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _incidentStatus = newValue!;
                });
              },
              items: <String>['Pending', 'Resolved', 'InProgress']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 15),
            CustomButton(
              text: 'Submit Report',
              onPressed: _submitReport,
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  void _submitReport() async {
    var location = await _locationService.getCurrentLocation();
    if (location != null) {
      String id = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Generating a unique ID based on current time
      DateTime timestamp = DateTime.now(); // Current time as the timestamp

      String? mediaUrl;
      if (_selectedMedia != null && _mediaType != null) {
        mediaUrl = await _uploadMedia(_selectedMedia!, _mediaType!);
        if (mediaUrl == null) {
          setState(() {
            _errorMessage = "Error uploading media. Please try again.";
          });
          return;
        }
      }

      IncidentStatus statusEnum = IncidentStatus.values.firstWhere(
        (e) => e.toString() == 'IncidentStatus.$_incidentStatus',
        orElse: () => IncidentStatus.Pending,
      );

      Incident incident = Incident(
        id: id,
        type: _incidentType,
        description: _descriptionController.text,
        latitude: location.latitude!,
        longitude: location.longitude!,
        mediaUrl: mediaUrl,
        mediaType: _mediaType,
        timestamp: timestamp,
        patrolRouteId: widget.patrolRouteId, // Assign the patrolRouteId here
        status: statusEnum, 
      );

      _addIncident(incident); 
      Navigator.pop(
          context); // Return to the dashboard or previous page after reporting
    } else {
      setState(() {
        _errorMessage =
            "Couldn't fetch location. Please enable location services.";
      });
    }
  }
}
