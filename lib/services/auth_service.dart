import 'package:firebase_auth/firebase_auth.dart' as auth; 
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:police_patrol_app/models/user.dart'; 

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; // Firestore instance

  // Helper method to fetch user role from Firestore
  Future<UserRole> getUserRole(String userId) async {
    DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
    return UserRole.values[(snapshot.data() as Map<String, dynamic>)['role']];
  }

  // Sign in with email and password
  Future<auth.User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserRole role =
          await getUserRole(userCredential.user!.uid); // Fetch user role
      // Store role in user model or in a global state

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<auth.User?> registerWithEmailAndPassword(
      String email, String password, UserRole role) async {
    try {
      auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the role in Firestore
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'role': role.index,
      });

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get the currently signed-in user
  auth.User? get currentUser => _auth.currentUser;

  // Stream to monitor authentication state changes
  Stream<auth.User?> get authStateChanges => _auth.authStateChanges();
}
