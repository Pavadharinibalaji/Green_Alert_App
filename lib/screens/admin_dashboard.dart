import 'package:flutter/material.dart';
import 'report_details_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> reports = [
    {
      'id': '001',
      'desc': 'Garbage pile near market',
      'status': 'Pending',
      'priority': 'Urgent',
      'imageName': 'e waste.jpg',
      'location': 'Chennai, Tamil Nadu',
    },
    {
      'id': '002',
      'desc': 'Sewage overflow on street',
      'status': 'Cleaned',
      'priority': 'Normal',
      'imageName': 'plastic waste.jpg',
      'location': 'Madurai, Tamil Nadu',
    },
    {
      'id': '003',
      'desc': 'Organic waste not collected',
      'status': 'On Progress',
      'priority': 'Medium',
      'imageName': 'organic waste.png',
      'location': 'Coimbatore, Tamil Nadu',
    },
  ];

  void _updateStatus(BuildContext context, int index) {
    setState(() {
      reports[index]['status'] = 'Cleaned';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Status updated for report ${reports[index]['id']}"),
      ),
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

          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/${report['imageName']}',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['desc'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("Status: ${report['status']}"),
                            Text("Priority: ${report['priority']}"),
                            Text("Location: ${report['location']}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateStatus(context, index),
                        child: Text("Mark Cleaned"),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportDetailsPage(report: report),
                            ),
                          );
                        },
                        child: Text("View Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
