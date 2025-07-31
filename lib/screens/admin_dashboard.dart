import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, String>> reports = [
    {
      'id' : '001',
      'desc' : 'Overflowing garbage near school',
      'status' : 'Pending',
    },
    {
      'id' : '002',
      'desc' : 'Broken streetlight in park',
      'status' : 'Resolved',
    },
  ];
  
  void _updateStatus(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Status updated for report ${reports[index]['id']}"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card (
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(report['desc']!),
              subtitle: Text("Status: ${report['status']}"),
              trailing: ElevatedButton(
                child: Text("Update"),
                onPressed: () => _updateStatus(context, index),
              ),
            ),
          );
        },
      ),
    );
  }
}