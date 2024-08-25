import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:police_patrol_app/models/user.dart';
import 'package:police_patrol_app/models/incident.dart';
import 'package:police_patrol_app/models/patrol_route.dart';
import 'package:police_patrol_app/models/resource.dart';
import 'package:police_patrol_app/models/officer.dart';
import 'package:police_patrol_app/models/patrol_report.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference incidentsCollection =
      FirebaseFirestore.instance.collection('incidents');
  // Reference to the patrol routes collection in Firestore
  final CollectionReference patrolRoutesCollection =
      FirebaseFirestore.instance.collection('patrolRoutes');
  // New collections
  final CollectionReference resourcesCollection =
      FirebaseFirestore.instance.collection('resources');
  final CollectionReference officersCollection =
      FirebaseFirestore.instance.collection('officers');
  final CollectionReference _patrolReportCollection =
      FirebaseFirestore.instance.collection('patrolReports');

  Future<void> addPreApprovalRequest(
      String email, UserRole selectedRole) async {
    await _firestore.collection('PreApprovedUsers').doc(email).set({
      'email': email,
      'isApproved': false,
      'role': selectedRole.toString(), 
    });
  }

  // Function to check if a user is pre-approved
  Future<bool> isUserPreApproved(String email) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('PreApprovedUsers').doc(email).get();
    return snapshot.exists && snapshot['isApproved'] == true;
  }

  // Function to register a new user
  Future<fbAuth.UserCredential?> registerUser(
      String email, String password, UserRole role) async {
    try {
      fbAuth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successfully creating the user, save additional information in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'role': role.toString(),
      });

      return userCredential;
    } catch (e) {
      print('Error occurred while registering: $e');
      return null;
    }
  }

  // Add a new user to Firestore
  Future<void> addUser(User user, UserRole role) async {
    // Role parameter added
    try {
      await usersCollection.doc(user.id).set({
        ...user.toJson(),
        'role': role.index, // Role is saved
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Update user role in Firestore
  Future<void> updateUserRole(String userId, UserRole role) async {
    try {
      await usersCollection.doc(userId).update({
        'role': role.index,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Get user data from Firestore
  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Check if 'role' exists and is a map with a 'role' key
        if (data.containsKey('role') && data['role'] is Map) {
          Map<String, dynamic> roleMap = data['role'] as Map<String, dynamic>;
          if (roleMap.containsKey('role')) {
            // Convert the integer role into an enum and replace in the data map
            data['role'] = UserRole.values[roleMap['role'] as int];
          }
        }

        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Add a new incident to Firestore
  Future<void> addIncident(Incident incident) async {
    try {
      await incidentsCollection.add(incident.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get a list of recent incidents from Firestore
  Stream<List<Incident>> getRecentIncidents() {
    return incidentsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Incident.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get a list of all incidents from Firestore
  Future<List<Incident>> getIncidents() async {
    try {
      QuerySnapshot querySnapshot = await incidentsCollection.get();
      return querySnapshot.docs.map((doc) {
        return Incident.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Incident>> getIncidentsForPatrolRoute(
      String patrolRouteId) async {
    try {
      // Query the incidentsCollection where the patrolRouteId matches the provided ID
      QuerySnapshot querySnapshot = await incidentsCollection
          .where('patrolRouteId', isEqualTo: patrolRouteId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No incidents found for patrolRouteId: $patrolRouteId");
        return [];
      }

      // Loop through each document and print its data (For debugging)
      for (var doc in querySnapshot.docs) {
        print("Document data: ${doc.data()}");
      }

      // Convert the results to a list of Incident objects
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        if (data == null) {
          print("Null data for document with ID: ${doc.id}");
        }
        return Incident.fromJson(data as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Add a new patrol route to Firestore
  Future<void> addPatrolRoute(PatrolRoute patrolRoute) async {
    return await patrolRoutesCollection
        .doc(patrolRoute.id)
        .set(patrolRoute.toJson());
  }

  // Retrieve all patrol routes recorded by a specific officer
  Stream<List<PatrolRoute>> getPatrolRoutesForOfficer(String officerId) {
    return patrolRoutesCollection
        .where('officerId', isEqualTo: officerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                PatrolRoute.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Update a specific patrol route
  Future<void> updatePatrolRoute(PatrolRoute patrolRoute) async {
    return await patrolRoutesCollection
        .doc(patrolRoute.id)
        .update(patrolRoute.toJson());
  }

  // Fetch all available resources (cars, equipment, manpower)
  Future<List<Resource>> getAllResources() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('resources').get();
      return querySnapshot.docs.map((doc) {
        return Resource.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Method to delete a resource by ID
  Future<void> deleteResource(String id) async {
    try {
      await resourcesCollection.doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Fetch all officer details
  Future<List<Officer>> getAllOfficers() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('officers').get();
      return querySnapshot.docs.map((doc) {
        return Officer.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Add a new resource to Firestore
  Future<void> addResource(Resource resource) async {
    try {
      await resourcesCollection.doc(resource.id).set(resource.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Add a new officer to Firestore
  Future<void> addOfficer(Officer officer) async {
    try {
      await officersCollection.doc(officer.id).set(officer.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Fetch all resources from Firestore
  Future<List<Resource>> getResources() async {
    try {
      QuerySnapshot querySnapshot = await resourcesCollection.get();
      return querySnapshot.docs.map((doc) {
        return Resource.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Fetch all officers from Firestore
  Future<List<Officer>> getOfficers() async {
    try {
      QuerySnapshot querySnapshot = await officersCollection.get();
      return querySnapshot.docs.map((doc) {
        return Officer.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Stream<List<User>> getOfficer() {
    return usersCollection
        .where('role', isEqualTo: UserRole.Officer.index)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Incident>> getAllIncidents() {
    return incidentsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Incident.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addPatrolReport(PatrolReport report) async {
    return _patrolReportCollection
        .doc(report.id)
        .set(report.toMap())
        .catchError((error) {
      throw Exception('Failed to add report: $error');
    });
  }

  Stream<List<PatrolReport>> getPatrolReportsForOfficer(String officerId) {
    return _patrolReportCollection
        .where('officerId', isEqualTo: officerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PatrolReport.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<PatrolReport?> getPatrolReportByIncident(Incident incident) async {
    try {
      // Assuming patrol reports have an attribute that references the associated incident's patrolRouteId
      QuerySnapshot querySnapshot = await _patrolReportCollection
          .where('patrolRouteId', isEqualTo: incident.patrolRouteId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print(
            "No patrol report found for incident with patrolRouteId: ${incident.patrolRouteId}");
        return null;
      }

      // Convert the first document (assuming only one report per incident) to a PatrolReport object
      return PatrolReport.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
