import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/models/categories.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class CreateStartupScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic> userData;

  CreateStartupScreen({required this.user, required this.userData});

  @override
  _CreateStartupScreenState createState() => _CreateStartupScreenState();
}

class _CreateStartupScreenState extends State<CreateStartupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  File? _videoFile;
  final _picker = ImagePicker();
  String? _selectedCategory;
  final List<Category> _categories = categories;
  bool _isLoading = false;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createStartup() async {
    if (_formKey.currentState!.validate() &&
        _imageFile != null &&
        _videoFile != null &&
        _selectedCategory != null) {
      setState(() {
        _isLoading = true;
      });

      final uuid = const Uuid();
      final uid = uuid.v4();

      try {
        final imageUrl = await _uploadFile(_imageFile!, 'startup_images');
        final videoUrl = await _uploadFile(_videoFile!, 'startup_videos');

        final startup = {
          'uid': uid,
          'name': _nameController.text,
          'description': _descriptionController.text,
          'image_url': imageUrl,
          'video_url': videoUrl,
          'category': _selectedCategory,
          'user_id': widget.user.uid,
          'user_name': widget.userData['username'] ?? widget.user.email,
          'createdAt': Timestamp.now(),
        };

        await FirebaseFirestore.instance
            .collection('startups')
            .doc(uid)
            .set(startup);
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Future<String> _uploadFile(File file, String folderName) async {
    String fileName = path.basename(file.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('$folderName/$fileName');
    UploadTask uploadTask = storageRef.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Startup'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the startup name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the startup description';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category.name,
                            child: Row(
                              children: [
                                Icon(category.icon, color: Colors.black87),
                                const SizedBox(width: 8),
                                Text(category.name),
                              ],
                            ),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.image, color: Colors.black),
                              label: const Text(
                                'Pick Image',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: _pickImageFromGallery,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.camera, color: Colors.black),
                              label: const Text(
                                'Take Image',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: _pickImageFromCamera,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _imageFile != null
                          ? Image.file(_imageFile!, height: 100)
                          : Container(),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.video_library,
                            color: Colors.black),
                        label: const Text(
                          'Select Video',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: _pickVideo,
                        style:
                            ElevatedButton.styleFrom(primary: Colors.grey[400]),
                      ),
                      _videoFile != null
                          ? Text('Video selected: ${_videoFile!.path}')
                          : Container(),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _createStartup,
                        style:
                            ElevatedButton.styleFrom(primary: Colors.grey[400]),
                        child: const Text(
                          'Add Startup',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
