import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String? _description;
  final String _location = "Auto-filled Location (GPS)";
  String? _imagePath;

  void _submitReport() {
    if (_description != null && _imagePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Report submitted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.grey[300],
              child: Center(child: Text("Image Upload Placeholder")),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: "Description"),
              onChanged:(val) => _description = val,
            ),
            SizedBox(height: 16),
            Text("Location: $_location"),
            Spacer(),
            ElevatedButton(
              onPressed: _submitReport,
              child: Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }
}