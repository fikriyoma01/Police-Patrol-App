import 'package:police_patrol_app/models/incident.dart';

class PatrolRoute {
  final String id; 
  final String officerId; 
  final DateTime startTime; // When the route recording started
  final DateTime?
      endTime; // When the route recording ended 
  final List<LocationPoint> locations; // List of recorded locations
  final List<Incident>?
      incidents; // List of incidents reported during the patrol

  PatrolRoute({
    required this.id,
    required this.officerId,
    required this.startTime,
    this.endTime,
    required this.locations,
    this.incidents,
  });

  // Convert a PatrolRoute object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'officerId': officerId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'locations': locations.map((location) => location.toJson()).toList(),
      'incidents': incidents?.map((incident) => incident.toJson()).toList(),
    };
  }

  // Convert a JSON map into a PatrolRoute object
  factory PatrolRoute.fromJson(Map<String, dynamic> json) {
    return PatrolRoute(
      id: json['id'],
      officerId: json['officerId'],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: json['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['endTime'])
          : null,
      locations: (json['locations'] as List)
          .map((locationJson) =>
              LocationPoint.fromJson(locationJson as Map<String, dynamic>))
          .toList(),
      incidents: (json['incidents'] as List?)
          ?.map((incidentJson) =>
              Incident.fromJson(incidentJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LocationPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  // Convert a LocationPoint object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Convert a JSON map into a LocationPoint object
  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}
