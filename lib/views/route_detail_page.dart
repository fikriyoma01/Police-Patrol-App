import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/patrol_route.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/models/user.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

class RouteDetailPage extends StatefulWidget {
  final PatrolRoute patrolRoute;

  RouteDetailPage({required this.patrolRoute});

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  final FirebaseService _firebaseService = FirebaseService();
  GoogleMapController? _mapController; 
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  DateTime? _selectedDate;
  String? _selectedIncidentType;
  String _searchQuery = '';
  String _selectedSortOrder = 'Date (Newest First)';

  List<Incident> _incidents = [];

  // List of sorting options for demonstration purposes
  List<String> _sortOptions = ['Date (Newest First)', 'Date (Oldest First)'];

  // List of incident types for demonstration purposes
  List<String> _incidentTypes = ['All Types', 'Theft', 'Assault', 'Accident'];

  @override
  void initState() {
    super.initState();
    _initMapElements();
    _fetchIncidentsForRoute();
    print("Incidents: ${widget.patrolRoute.incidents}");
  }

  void _fetchIncidentsForRoute() async {
    List<Incident> incidents = await _firebaseService
        .getIncidentsForPatrolRoute(widget.patrolRoute.id);
    print("Fetched incidents: $incidents"); // Debug line
    setState(() {
      _incidents = incidents;
    });
    _initMapElements(); // re-initialize map elements
  }

  void _initMapElements() {
    LatLngBounds bounds = _calculateBounds(widget.patrolRoute.locations);

    // Check if _mapController is not null before using it
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

    LatLng startLatLng = LatLng(widget.patrolRoute.locations.first.latitude,
        widget.patrolRoute.locations.first.longitude);
    LatLng endLatLng = LatLng(widget.patrolRoute.locations.last.latitude,
        widget.patrolRoute.locations.last.longitude);

    _markers.add(Marker(
      markerId: MarkerId('start'),
      position: startLatLng,
      infoWindow: InfoWindow(title: 'Start'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    _markers.add(Marker(
      markerId: MarkerId('end'),
      position: endLatLng,
      infoWindow: InfoWindow(title: 'End'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));

    _polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: widget.patrolRoute.locations
          .map((loc) => LatLng(loc.latitude, loc.longitude))
          .toList(),
      color: Colors.blue,
    ));

    setState(() {
      // Adding markers for incidents
      for (var incident in _incidents) {
        // Use _incidents here
        _markers.add(Marker(
          markerId: MarkerId(incident.id),
          position: LatLng(incident.latitude, incident.longitude),
          infoWindow:
              InfoWindow(title: 'Incident', snippet: incident.description),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ));
      }
    });
  }

  LatLngBounds _calculateBounds(List<LocationPoint> locations) {
    double minLat = locations.first.latitude;
    double maxLat = locations.first.latitude;
    double minLng = locations.first.longitude;
    double maxLng = locations.first.longitude;

    for (var location in locations) {
      if (location.latitude < minLat) minLat = location.latitude;
      if (location.latitude > maxLat) maxLat = location.latitude;
      if (location.longitude < minLng) minLng = location.longitude;
      if (location.longitude > maxLng) maxLng = location.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _zoomToIncident(Incident incident) {
    _mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(incident.latitude, incident.longitude),
        18.0 // High zoom level for a closer view
        ));
  }

  void _viewMedia(String mediaUrl, String mediaType) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FullScreenMediaView(mediaUrl: mediaUrl, mediaType: mediaType)));
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.patrolRoute.startTime,
      lastDate: widget.patrolRoute.endTime ??
          DateTime.now(), // Fallback to current date/time if endTime is null
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _resetFilter() {
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration patrolDuration = (widget.patrolRoute.endTime ?? DateTime.now())
        .difference(widget.patrolRoute.startTime);

    List<Incident> filteredIncidents = _incidents;

    // Apply date filter
    if (_selectedDate != null) {
      filteredIncidents = filteredIncidents
          .where((incident) =>
              incident.timestamp.toLocal().day == _selectedDate!.day &&
              incident.timestamp.toLocal().month == _selectedDate!.month &&
              incident.timestamp.toLocal().year == _selectedDate!.year)
          .toList();
    }

    // Apply incident type filter
    if (_selectedIncidentType != null && _selectedIncidentType != 'All Types') {
      filteredIncidents = filteredIncidents
          .where((incident) => incident.type == _selectedIncidentType)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredIncidents = filteredIncidents
          .where((incident) => (incident.description).contains(_searchQuery))
          .toList();
    }

    // Apply sorting logic
    if (_selectedSortOrder == 'Date (Newest First)') {
      filteredIncidents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else if (_selectedSortOrder == 'Date (Oldest First)') {
      filteredIncidents.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildInfoTile('Start Time',
                  widget.patrolRoute.startTime.toLocal().toString()),
              _buildInfoTile(
                  'End Time', widget.patrolRoute.endTime!.toLocal().toString()),
              _buildInfoTile('Duration', '${patrolDuration.inMinutes} mins'),
              SizedBox(height: 20),
              Container(
                height: 250, // Set a fixed height for the map view
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    _initMapElements();
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.patrolRoute.locations.first.latitude,
                        widget.patrolRoute.locations.first.longitude),
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Incidents',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // Incident reports listing goes here

              // Dropdown for incident types
              DropdownButton<String>(
                value: _selectedIncidentType ?? 'All Types',
                onChanged: (newValue) {
                  setState(() {
                    _selectedIncidentType = newValue;
                  });
                },
                items: _incidentTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              // Listing filtered incidents
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredIncidents.length,
                itemBuilder: (context, index) {
                  Incident incident = filteredIncidents[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey[100],
                        child: (incident.mediaType == 'image' &&
                                incident.mediaUrl != null)
                            ? ClipOval(
                                child: Image.network(
                                  incident.mediaUrl ?? 'default_image_url',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.warning,
                                color: Colors.red,
                                size:
                                    28), // Fallback to warning icon if not an image
                      ),
                      title: Text(
                        incident.description,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        incident.timestamp.toLocal().toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: incident.mediaUrl != null
                          ? GestureDetector(
                              onTap: () => _viewMedia(incident.mediaUrl!,
                                  incident.mediaType ?? 'defaultType'),
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.blueGrey,
                                size: 30,
                              ),
                            )
                          : null,
                      onTap: () => _zoomToIncident(incident),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}

class FullScreenMediaView extends StatefulWidget {
  final String mediaUrl;
  final String mediaType;

  FullScreenMediaView({required this.mediaUrl, required this.mediaType});

  @override
  _FullScreenMediaViewState createState() => _FullScreenMediaViewState();
}

class _FullScreenMediaViewState extends State<FullScreenMediaView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _controller = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media View'),
      ),
      body: Center(
        child: widget.mediaType == 'image'
            ? Image.network(widget.mediaUrl, fit: BoxFit.cover)
            : Container(
                // child: VideoPlayer(_controller!),
                
                child: Text('Video Player Placeholder'),
              ),
      ),
    );
  }

  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }
}
