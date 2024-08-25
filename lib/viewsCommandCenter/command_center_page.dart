import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/services/auth_service.dart'; 

class CommandCenterPage extends StatefulWidget {
  @override
  _CommandCenterPageState createState() => _CommandCenterPageState();
}

class _CommandCenterPageState extends State<CommandCenterPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService(); // Initialize the AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command Center'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Get.offAllNamed('/login'); // Navigate back to login
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // _buildListTile(
          //   title: 'Resource Management',
          //   icon: Icons.manage_accounts,
          //   onTap: () => Get.toNamed('/resourceManagement'),
          // ),
          _buildListTile(
            title: 'Incident Dashboard',
            icon: Icons.dashboard,
            onTap: () => Get.toNamed('/incidentDashboard'),
          ),
          // _buildListTile(
          //   title: 'Officer Monitoring',
          //   icon: Icons.security,
          //   onTap: () => Get.toNamed('/officerMonitoring'),
          // ),
          // _buildListTile(
          //   title: 'Incident Management',
          //   icon: Icons.warning,
          //   onTap: () => Get.toNamed('/incidentManagement'),
          // ),
          _buildListTile(
            title: 'Data Analytics',
            icon: Icons.bar_chart,
            onTap: () {},
          ),
          // _buildListTile(
          //   title: 'Historical Data',
          //   icon: Icons.history,
          //   onTap: () {},
          // ),
          // _buildListTile(
          //   title: 'Alerts and Notifications',
          //   icon: Icons.notifications,
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }

  ListTile _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}
