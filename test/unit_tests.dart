import 'package:flutter_test/flutter_test.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/models/patrol_report.dart';
import 'package:police_patrol_app/models/patrol_route.dart';
import 'package:police_patrol_app/models/officer.dart';

void main() {
  // Group all tests related to Incident model
  group('Incident Model Test', () {
    test('Incident can be created from JSON', () {
      final json = {
        'id': '1',
        'latitude': 37.42796133580664,
        'longitude': -122.085749655962,
        'description': 'Test Incident',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': 0,
      };

      final incident = Incident.fromJson(json);

      expect(incident.id, '1');
      expect(incident.latitude, 37.42796133580664);
      expect(incident.longitude, -122.085749655962);
      expect(incident.description, 'Test Incident');
      expect(incident.status, IncidentStatus.Pending);
    });

    test('Incident can be converted to JSON', () {
      final incident = Incident(
        id: '1',
        latitude: 37.42796133580664,
        longitude: -122.085749655962,
        description: 'Test Incident',
        timestamp: DateTime.now(),
        status: IncidentStatus.Pending,
      );

      final json = incident.toJson();

      expect(json['id'], '1');
      expect(json['latitude'], 37.42796133580664);
      expect(json['longitude'], -122.085749655962);
      expect(json['description'], 'Test Incident');
      expect(json['status'], 0);
    });
  });

  // Group all tests related to PatrolReport model
  group('PatrolReport Model Test', () {
    test('PatrolReport can be created from Map', () {
      final map = {
        'id': '1',
        'officerId': 'officer1',
        'warrantDateTime': DateTime.now().toIso8601String(),
        'typeOfPatrol': 'Routine Patrol',
        'natureOfPatrol': 'Standard',
        'isFootPatrol': true,
        'numberOfPersonnel': 3,
        'patrolRouteId': 'route1', 
      };

      final patrolReport = PatrolReport.fromMap(map);

      expect(patrolReport.id, '1');
      expect(patrolReport.officerId, 'officer1');
      expect(patrolReport.typeOfPatrol, 'Routine Patrol');
      expect(patrolReport.natureOfPatrol, 'Standard');
      expect(patrolReport.isFootPatrol, true);
      expect(patrolReport.numberOfPersonnel, 3);
      expect(patrolReport.patrolRouteId, 'route1');
    });

    test('PatrolReport can be converted to Map', () {
      final patrolReport = PatrolReport(
        id: '1',
        officerId: 'officer1',
        warrantDateTime: DateTime.now(),
        typeOfPatrol: 'Routine Patrol',
        natureOfPatrol: 'Standard',
        isFootPatrol: true,
        numberOfPersonnel: 3,
        patrolRouteId: '1',
      );

      final map = patrolReport.toMap();

      expect(map['id'], '1');
      expect(map['officerId'], 'officer1');
      expect(map['typeOfPatrol'], 'Routine Patrol');
      expect(map['natureOfPatrol'], 'Standard');
      expect(map['isFootPatrol'], true);
      expect(map['numberOfPersonnel'], 3);
      expect(map['patrolRouteId'], '1');
    });
  });

  // Group all tests related to PatrolRoute model
  group('PatrolRoute Model Test', () {
    test('PatrolRoute can be created from JSON', () {
      final json = {
        'id': 'route1',
        'officerId': 'officer1',
        'startTime': DateTime.now().millisecondsSinceEpoch, // millisecondsSinceEpoch to match int type
        'endTime': DateTime.now().millisecondsSinceEpoch, // millisecondsSinceEpoch to match int type
        'locations': [
          {
            'latitude': 37.42796133580664,
            'longitude': -122.085749655962,
            'timestamp': DateTime.now().millisecondsSinceEpoch, // millisecondsSinceEpoch to match int type
          }
        ]
      };

      final patrolRoute = PatrolRoute.fromJson(json);

      expect(patrolRoute.id, 'route1');
      expect(patrolRoute.officerId, 'officer1');
      expect(patrolRoute.locations.length, 1);
      expect(patrolRoute.locations.first.latitude, 37.42796133580664);
      expect(patrolRoute.locations.first.longitude, -122.085749655962);
    });

    test('PatrolRoute can be converted to JSON', () {
      final patrolRoute = PatrolRoute(
        id: 'route1',
        officerId: 'officer1',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        locations: [
          LocationPoint(
            latitude: 37.42796133580664,
            longitude: -122.085749655962,
            timestamp: DateTime.now(),
          )
        ],
      );

      final json = patrolRoute.toJson();

      expect(json['id'], 'route1');
      expect(json['officerId'], 'officer1');
      expect((json['locations'] as List).length, 1);
      expect(json['locations'][0]['latitude'], 37.42796133580664);
      expect(json['locations'][0]['longitude'], -122.085749655962);
    });
  });

  // Group all tests related to Officer model
  group('Officer Model Test', () {
    test('Officer can be created from JSON', () {
      final json = {
        'id': 'officer1',
        'name': 'John Doe',
        'rank': 'Sergeant',
        'patrolUnit': '12345',
        'status': 'On Duty'
      };

      final officer = Officer.fromJson(json);

      expect(officer.id, 'officer1');
      expect(officer.name, 'John Doe');
      expect(officer.rank, 'Sergeant');
      expect(officer.patrolUnit, '12345');
      expect(officer.status, 'On Duty');
    });

    test('Officer can be converted to JSON', () {
      final officer = Officer(
        id: 'officer1',
        name: 'John Doe',
        rank: 'Sergeant',
        patrolUnit: '12345',
        status: 'On Duty',
      );

      final json = officer.toJson();

      expect(json['id'], 'officer1');
      expect(json['name'], 'John Doe');
      expect(json['rank'], 'Sergeant');
      expect(json['patrolUnit'], '12345');
      expect(json['status'], 'On Duty');
    });
  });
}
