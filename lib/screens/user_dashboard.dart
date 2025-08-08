import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String? _description;
  final String _location = "Auto-filled Location (GPS)";
  String? _selectedPriority = 'Normal';
  String adminStatus = "Pending";

  File? _imageFile;
  File? _videoFile;
  VideoPlayerController? _videoController;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      _videoFile = File(pickedVideo.path);
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.setLooping(true);
          _videoController?.play();
        });
    }
  }

  void _submitReport() {
    if (_description != null && _imageFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Report submitted successfully!\nPriority: $_selectedPriority",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please complete all fields")));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildVideoPreview() {
    if (_videoFile == null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: ElevatedButton.icon(
            icon: Icon(Icons.video_call),
            label: Text("Upload Video"),
            onPressed: _pickVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    } else if (_videoController != null &&
        _videoController!.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      );
    } else {
      return Text("Loading video...");
    }
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text("No image selected")),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_imageFile!, height: 150),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'On Progress':
        return Colors.blue;
      case 'Cleaning':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.account_circle, size: 28),
          onPressed: () {
            Navigator.pushNamed(context, '/admin');
          },
        ),
        title: Text("User Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImagePreview(),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.photo),
              label: Text("Upload Photo"),
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildVideoPreview(), // Only this used for video preview
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Description",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => _description = val,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              items: ['Urgent', 'Normal', 'Large Scale', 'Minor']
                  .map(
                    (priority) => DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Select Priority',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Status (Updated by Admin)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              child: Text(
                adminStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(adminStatus),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Location: $_location"),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              child: Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }
}
