import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCoursePage extends StatefulWidget {
  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  List<String> _selectedCategories = []; // Changed to a list

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Course'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: _imageFile == null
                        ? Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Image.file(
                            File(_imageFile!.path),
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _courseNameController,
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _courseDescriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Course Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: null,
                          hint: Text('Select Category'),
                          onChanged: (newValue) {
                            if (newValue != null &&
                                !_selectedCategories.contains(newValue)) {
                              setState(() {
                                _selectedCategories.add(newValue);
                              });
                            }
                          },
                          items: _categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    children: _selectedCategories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Chip(
                          label: Text(category),
                          onDeleted: () {
                            setState(() {
                              _selectedCategories.remove(category);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add your logic to save the course
            },
            child: Text('Create Course'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  static const List<String> _categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4'
  ];
}
