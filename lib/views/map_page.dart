import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:police_patrol_app/views/patrol_report_page.dart';
import 'package:police_patrol_app/views/report_page.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/models/patrol_route.dart';
import 'package:police_patrol_app/services/auth_service.dart';
import 'package:police_patrol_app/services/location_service.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late GoogleMapController _mapController;
  List<LocationPoint> _currentRoute = [];
  StreamSubscription? _locationSubscription;
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Marker> _markers = Set<Marker>();
  DateTime? _selectedDate;
  List<PatrolRoute> _allRoutes = [];
  StreamSubscription? _routesSubscription;
  PatrolRoute? _selectedRoute;
  // final ValueNotifier<bool> _isRecording = ValueNotifier<bool>(false);
  // bool _isRecording = false;
  String? _currentPatrolRouteId; 
  GoogleMap? _googleMap;

  @override
  void initState() {
    super.initState();
    _loadIncidents().then((incidents) {
      Get.find<MapController>()
          .setIncidents(incidents); // Update incidents in controller
      Get.find<MapController>()
          ._updateIncidentMarkers(); // Add incident markers
    });
    _setUserLocation();

    // Listen to patrol routes updates from Firestore in real-time
    _routesSubscription = _firebaseService
        .getPatrolRoutesForOfficer(AuthService().currentUser!.uid)
        .listen((routes) {
      setState(() {
        _allRoutes = routes;
      });
      routes.forEach((route) {
        Get.find<MapController>()
            ._addRouteMarkers(route); // Add route markers for each route
      });
    });
  }

  // Start recording patrol route
  void _startRouteRecording() {
    // Generate a unique ID for the current patrol route at the start of recording
    // _currentPatrolRouteId = Uuid().v1();
    Get.find<MapController>()._currentRoute.clear();
    _locationSubscription = LocationService().locationStream.listen((location) {
      if (location.latitude != null && location.longitude != null) {
        _currentRoute.add(LocationPoint(
          latitude: location.latitude!,
          longitude: location.longitude!,
          timestamp: DateTime.now(),
        ));
      } else {
        // Handle the case where latitude or longitude is null, if needed
      }
    });
  }

  // Stop recording and save patrol route
  void _stopRouteRecording() {
    _locationSubscription?.cancel();
    if (_currentRoute.isNotEmpty) {
      PatrolRoute patrolRoute = PatrolRoute(
        id: _currentPatrolRouteId!,
        officerId: AuthService().currentUser!.uid,
        startTime: _currentRoute.first.timestamp,
        endTime: _currentRoute.last.timestamp,
        locations: _currentRoute,
      );
      _firebaseService.addPatrolRoute(patrolRoute).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Route recording stopped and saved.'),
        ));
        Get.find<MapController>()._addRouteMarkers(patrolRoute);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error saving route. Please try again.'),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No route recorded.'),
      ));
    }
    _currentPatrolRouteId = null; // Reset the current patrol route ID
  }


  void _addIncident(Incident incident) {
    if (_currentPatrolRouteId != null) {
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
        patrolRouteId:
            _currentPatrolRouteId, // Associate incident with the current patrol route
        status: IncidentStatus.Pending, 
      );
      _firebaseService.addIncident(newIncident);
    }
  }

  Polyline _routeToPolyline(PatrolRoute route) {
    return Polyline(
      polylineId: PolylineId(route.id),
      color: Colors.blue,
      points: route.locations
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
    );
  }

  void _updatePolylines() {
    if (_selectedRoute != null) {
      setState(() {
        _polylines.add(_routeToPolyline(_selectedRoute!));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  List<PatrolRoute> _fetchPatrolRoutesForDate(DateTime? date) {
    if (date == null) {
      return _allRoutes;
    }
    return _allRoutes.where((route) {
      return route.startTime.year == date.year &&
          route.startTime.month == date.month &&
          route.startTime.day == date.day;
    }).toList();
  }

  Future<void> _setUserLocation() async {
    LatLng? userLocation = await _getCurrentUserLocation();
    if (userLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation, 15),
      );
    }
  }

  Future<LatLng?> _getCurrentUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return LatLng(_locationData.latitude!, _locationData.longitude!);
  }

  Future<List<Incident>> _loadIncidents() async {
    List<Incident> incidents = await _firebaseService.getIncidents();
    Get.find<MapController>().setIncidents(incidents);
    return incidents;
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<MapController>() == false) {
      Get.put(MapController());
    }
    if (_googleMap == null) {
      _googleMap = GoogleMap(
        key: ValueKey(DateTime.now()
            .millisecondsSinceEpoch), // this based on user's current location or another stable value
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(0,
              0), // Default to (0,0) but will be updated once the user location is fetched
          zoom: 10.0,
        ),
        markers: Get.find<MapController>()._markers,
        polylines: _polylines,
      );
    }

    FutureBuilder<List<Incident>>(
      future: _loadIncidents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          _markers = snapshot.data!.map((incident) {
            return Marker(
              markerId: MarkerId(incident.id),
              position: LatLng(incident.latitude, incident.longitude),
              infoWindow: InfoWindow(
                  title: incident.type, snippet: incident.description),
            );
          }).toSet();

          return GoogleMap(
            key: ValueKey(
                DateTime.now().millisecondsSinceEpoch), 
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(0,
                  0), // Default to (0,0) but will be updated once the user location is fetched
              zoom: 10.0,
            ),
            markers: Get.find<MapController>()._markers,
            polylines: _polylines,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );

    // Get screen size
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    // Decide on font size based on screen width
    double fontSize = width > 600 ? 24 : 18;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Patrol Map',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
      body: Stack(
        children: [
          _googleMap!,
          
          Positioned(
            left: 16.0, 
            bottom: 16.0, 
            child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              visible: true, // Toggle visibility of dial
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              tooltip: 'Speed Dial',
              heroTag: 'speed-dial-hero-tag',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 8.0,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                  child: Obx(() => Icon(
                      Get.find<MapController>().isRecording.value
                          ? Icons.stop
                          : Icons.play_arrow)),
                  backgroundColor: Get.find<MapController>().isRecording.value
                      ? Colors.red
                      : Colors.green,
                  label: Get.find<MapController>().isRecording.value
                      ? 'Stop Recording'
                      : 'Start Recording',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () {
                    if (Get.find<MapController>().isRecording.value) {
                      Get.find<MapController>().stopRecording();
                    } else {
                      Get.find<MapController>().initiateRecording(context);
                    }
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.add_alert),
                  backgroundColor: Colors.blue,
                  label: 'Report Incident',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                            patrolRouteId:
                                Get.find<MapController>().currentPatrolRouteId),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _routesSubscription?.cancel();
    super.dispose();
  }
}

class MapController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  List<LocationPoint> _currentRoute = [];
  StreamSubscription? _locationSubscription;
  String? _currentPatrolRouteId;
  List<Incident> _incidents = [];
  Set<Marker> _markers = Set<Marker>();

  // Make this public so that it can be accessed from _MapPageState
  String? get currentPatrolRouteId => _currentPatrolRouteId;

  RxBool isRecording = false.obs;

  void initiateRecording(BuildContext context) {
    _currentPatrolRouteId = Uuid().v1(); // Generate the ID here
    // Navigate to PatrolReportPage and start recording if the report is valid
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatrolReportPage(
          onReportSubmitted: () {
            startRecording();
          },
          patrolRouteId: _currentPatrolRouteId, // Pass the ID directly
        ),
      ),
    );
  }

  void startRecording() {
    isRecording.value = true;
    _startRouteRecording();
  }

  void stopRecording() {
    isRecording.value = false;
    _stopRouteRecording();
  }

  void toggleRecording() {
    isRecording.value = !isRecording.value;
    if (isRecording.value) {
      _startRouteRecording();
    } else {
      _stopRouteRecording();
    }
  }

  void setIncidents(List<Incident> incidents) {
    _incidents = incidents;
    _updateIncidentMarkers();
  }

  void _addRouteMarkers(PatrolRoute route) {
    _markers.add(Marker(
      markerId: MarkerId('start_${route.id}'),
      position: LatLng(
          route.locations.first.latitude, route.locations.first.longitude),
      infoWindow: InfoWindow(title: 'Start'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    _markers.add(Marker(
      markerId: MarkerId('end_${route.id}'),
      position:
          LatLng(route.locations.last.latitude, route.locations.last.longitude),
      infoWindow: InfoWindow(title: 'End'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  void _updateIncidentMarkers() {
    _markers.addAll(_incidents.map((incident) {
      return Marker(
        markerId: MarkerId(incident.id),
        position: LatLng(incident.latitude, incident.longitude),
        infoWindow: InfoWindow(
          title: incident.type,
          snippet: incident.description,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        ),
      );
    }));
  }

  void _startRouteRecording() {
    // Generate a unique ID for the current patrol route at the start of recording
    // _currentPatrolRouteId = Uuid().v1();
    _currentRoute.clear();
    _locationSubscription = LocationService().locationStream.listen((location) {
      if (location.latitude != null && location.longitude != null) {
        _currentRoute.add(LocationPoint(
          latitude: location.latitude!,
          longitude: location.longitude!,
          timestamp: DateTime.now(),
        ));
      } else {
        // Handle the case where latitude or longitude is null, if needed
      }
    });
  }

  void _stopRouteRecording() {
    _locationSubscription?.cancel();
    if (_currentRoute.isNotEmpty) {
      PatrolRoute patrolRoute = PatrolRoute(
        id: _currentPatrolRouteId!,
        officerId: AuthService().currentUser!.uid,
        startTime: _currentRoute.first.timestamp,
        endTime: _currentRoute.last.timestamp,
        locations: _currentRoute,
      );
      _firebaseService.addPatrolRoute(patrolRoute).then((_) {
        // Using Get's built-in snackbar for displaying messages
        Get.snackbar('Route Recording', 'Route recording stopped and saved.');
        _addRouteMarkers(patrolRoute);
      }).catchError((error) {
        Get.snackbar(
            'Route Recording', 'Error saving route. Please try again.');
      });
    } else {
      Get.snackbar('Route Recording', 'No route recorded.');
    }
    _currentPatrolRouteId = null; // Reset the current patrol route ID
  }
}
