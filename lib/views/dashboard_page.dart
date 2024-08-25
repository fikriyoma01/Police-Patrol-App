import 'package:flutter/material.dart';
import 'package:police_patrol_app/services/auth_service.dart';
import 'package:police_patrol_app/utils/constants.dart';
import 'package:police_patrol_app/widgets/custom_button.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.popAndPushNamed(context, '/login');
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/background.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(DEFAULT_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to the Police Patrol Dashboard!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 20),
              _buildDashboardCard(
                title: 'View Incidents',
                imageAsset: 'images/map.png',
                onTap: () => Navigator.pushNamed(context, '/map'),
              ),
              SizedBox(height: 10),
              _buildDashboardCard(
                title: 'Chat with Team',
                imageAsset: 'images/chat.png',
                onTap: () => Navigator.pushNamed(context, '/chat'),
              ),
              SizedBox(height: 10),
              _buildDashboardCard(
                title: 'Report View',
                imageAsset: 'images/report.png',
                onTap: () => Navigator.pushNamed(context, '/reportView'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(
                      0.6), // Attractive blue with some transparency
                  BlendMode
                      .srcOver, // This blend mode overlays the blue color on the image
                ),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.9),
                          blurRadius:
                              10.0, 
                          spreadRadius:
                              5.0, 
                          offset: Offset(
                            0.0, 
                            0.0, 
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
