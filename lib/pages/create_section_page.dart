import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

class CreateSectionPage extends StatefulWidget {
  @override
  _CreateSectionPageState createState() => _CreateSectionPageState();
}

class _CreateSectionPageState extends State<CreateSectionPage> {
  late VideoPlayerController _videoController;
  File? _videoFile;
  List<File> _documents = [];
  TextEditingController _sectionNameController = TextEditingController();
  TextEditingController _sectionContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
        ..initialize().then((_) {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _videoFile = file;
        _videoController = VideoPlayerController.file(_videoFile!);
        _videoController.initialize().then((_) {
          setState(() {});
        });
      });
    }
  }

  void _removeVideo() {
    setState(() {
      _videoFile = null;
      _videoController.dispose();
    });
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _documents.add(file);
      });
    }
  }

  void _removeDocument(File document) {
    setState(() {
      _documents.remove(document);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Section'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _sectionNameController,
              decoration: InputDecoration(
                labelText: 'Section Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _sectionContentController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Section Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _buildVideoSection(),
            SizedBox(height: 20),
            _buildDocumentSection(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to save section details
              },
              child: Text('Save Section'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video Upload',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _videoFile != null
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_videoController.value.isPlaying) {
                              _videoController.pause();
                            } else {
                              _videoController.play();
                            }
                          });
                        },
                        icon: Icon(_videoController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          final newValue = _videoController.value.position.inSeconds + 10;
                          _videoController.seekTo(Duration(seconds: newValue));
                        },
                        icon: Icon(Icons.forward_10),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _removeVideo,
                    icon: Icon(Icons.remove_circle),
                    label: Text('Remove Video'),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: Icon(Icons.video_library),
                label: Text('Upload Video'),
              ),
      ],
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documents',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _documents
              .map(
                (document) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(document.path.split('/').last)),
                      IconButton(
                        onPressed: () => _removeDocument(document),
                        icon: Icon(Icons.remove_circle),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickDocument,
          icon: Icon(Icons.attach_file),
          label: Text('Upload Document'),
        ),
      ],
    );
  }
}
