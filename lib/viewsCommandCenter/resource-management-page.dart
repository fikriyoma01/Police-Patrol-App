import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/resource.dart';
import 'package:police_patrol_app/services/firebase_service.dart';
import 'package:police_patrol_app/viewsCommandCenter/add-resource-page.dart';

class ResourceManagementPage extends StatefulWidget {
  @override
  _ResourceManagementPageState createState() => _ResourceManagementPageState();
}

class _ResourceManagementPageState extends State<ResourceManagementPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Resource> resources = [];

  @override
  void initState() {
    super.initState();
    // Fetch resources from Firebase for future
    // For prototype, let's initialize the list here
    resources = [
      Resource(id: '1', name: 'Car 1', type: 'Car', status: 'Available'),
      // ... more resources
    ];
  }

  void _addResource(Resource resource) {
    setState(() {
      resources.add(resource);
    });
  }

  void _deleteResource(String id) {
    setState(() {
      resources.removeWhere((r) => r.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resource Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddResourcePage(
                    addResourceCallback: _addResource,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return ListTile(
            title: Text(resource.name),
            subtitle:
                Text('Type: ${resource.type}, Status: ${resource.status}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteResource(resource.id),
            ),
          );
        },
      ),
    );
  }
}
