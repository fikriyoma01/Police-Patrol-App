import 'package:flutter/material.dart';
import 'package:police_patrol_app/views/dashboard_page.dart';
import 'package:police_patrol_app/viewsCommandCenter/command_center_page.dart'; 
import 'package:police_patrol_app/services/auth_service.dart';
import 'package:police_patrol_app/services/firebase_service.dart'; 
import 'package:police_patrol_app/models/user.dart'; 
import 'package:police_patrol_app/utils/constants.dart';
import 'package:police_patrol_app/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_TITLE)),
      body: Padding(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) => setState(() => _email = val),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) => setState(() => _password = val),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Login',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic user = await _authService
                        .signInWithEmailAndPassword(_email, _password);
                    if (user == null) {
                      setState(() => _errorMessage =
                          'Could not login with those credentials');
                    } else {
                      print(
                          "User is not null, fetching details..."); // Debug line
                      // Fetch the user's role from Firebase
                      User? userDetails =
                          await _firebaseService.getUser(user.uid);
                      print("Fetched user details: $userDetails"); // Debug line
                      print('UserRole: ${userDetails?.role}');
                      if (userDetails != null &&
                          userDetails.role == UserRole.CommandCenter) {
                        // Navigate to CommandCenterPage if the user's role is CommandCenter
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommandCenterPage()),
                        );
                      } else {
                        // Navigate to DashboardPage for other roles
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()),
                        );
                      }
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Register',
                onPressed: () {
                  // Navigate to the registration page
                  Navigator.pushNamed(context, '/register');
                  
                },
              ),
              SizedBox(height: 20),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
