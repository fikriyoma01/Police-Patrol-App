enum IncidentStatus { Pending, Resolved, InProgress }

class Incident {
  final String id;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime timestamp;
  final String? reportedBy;
  final String? type;
  final String? mediaUrl; 
  final String?
      mediaType; 
  final String? patrolRouteId; 
  final IncidentStatus? status; 

  Incident({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.timestamp,
    this.reportedBy,
    this.type,
    this.mediaUrl,
    this.mediaType,
    this.patrolRouteId, 
    required this.status, 
  });

  // Convert an Incident object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'reportedBy': reportedBy,
      'type': type,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'patrolRouteId': patrolRouteId, 
      'status': status!.index, 
    };
  }

  // Convert a JSON map into an Incident object
  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      reportedBy: json['reportedBy'],
      type: json['type'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      patrolRouteId: json['patrolRouteId'], 
      status: json['status'] != null
          ? IncidentStatus.values[json['status']]
          : null,
    );
  }
}
