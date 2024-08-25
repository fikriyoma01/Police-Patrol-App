import 'package:flutter/material.dart';
import 'package:police_patrol_app/models/resource.dart';

class AddResourcePage extends StatefulWidget {
  final Function addResourceCallback;

  AddResourcePage({required this.addResourceCallback});

  @override
  _AddResourcePageState createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = 'Car';
  String _status = 'Available';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Resource'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                onChanged: (val) => _name = val,
              ),
              DropdownButtonFormField<String>(
                value: _type,
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
                items: ['Car', 'Equipment', 'Manpower']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: ['Available', 'In Use']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Resource newResource = Resource(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type,
                      status: _status,
                    );
                    widget.addResourceCallback(newResource);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Resource'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
