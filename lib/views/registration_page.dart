import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:police_patrol_app/services/auth_service.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/utils/constants.dart';
import 'package:police_patrol_app/widgets/custom_button.dart';
import 'package:police_patrol_app/models/user.dart'; 

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  UserRole _selectedRole = UserRole.Public; // Default to 'Public'
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create an Account',
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
              DropdownButtonFormField<UserRole>(
                decoration: InputDecoration(labelText: 'Role'),
                value: _selectedRole,
                items: UserRole.values.map((UserRole role) {
                  return DropdownMenuItem<UserRole>(
                    value: role,
                    child: Text(role.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (UserRole? newRole) {
                  setState(() {
                    _selectedRole = newRole!;
                  });
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Register',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Check if the email is pre-approved
                    DocumentSnapshot snapshot = await _firestore
                        .collection('PreApprovedUsers')
                        .doc(_email)
                        .get();

                    if (snapshot.exists && snapshot['isApproved'] == true) {
                      // User is pre-approved, proceed with registration
                      dynamic user =
                          await _authService.registerWithEmailAndPassword(
                        _email,
                        _password,
                        _selectedRole, // Pass the selected role
                      );
                      if (user == null) {
                        setState(() => _errorMessage =
                            'Registration failed. Please try again.');
                      } else {
                        Navigator.pop(context);
                        
                      }
                    } else {
                      // User is not pre-approved, add them to the PreApprovedUsers collection
                      await FirebaseService()
                          .addPreApprovalRequest(_email, _selectedRole);

                      // Show a message
                      setState(() => _errorMessage =
                          'You are not pre-approved to register. Your request has been submitted for approval.');
                    }
                  }
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
