import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/utils/graphq_create_section.dart';
import 'package:leare_fa/utils/graphql_section.dart';
import 'package:leare_fa/utils/upload_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class EditSectionArguments {
  final String section_id;
  final String module_id;
  final int pos_index;
  EditSectionArguments(this.section_id, this.module_id, this.pos_index);
}

class EditSectionPage extends StatefulWidget {
  final String section_id;
  final String module_id;
  final int pos_index;

  const EditSectionPage({super.key, this.section_id ='' ,this.module_id = '', this.pos_index = 0});
  
  @override
  _EditSectionPageState createState() => _EditSectionPageState();
}

class _EditSectionPageState extends State<EditSectionPage> {
  late SharedPreferences prefs;
  bool isLoading = true;
  SectionModel section = SectionModel(
    section_id: '',
    section_name: '',
    section_content: '',
    video_id: '',
    files_array: [],
    pos_index: 0,
  );
  String? userId;
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  File? _videoFile;
  List<File> _documents = [];
  TextEditingController _sectionNameController = TextEditingController();
  TextEditingController _sectionContentController = TextEditingController();
  var args;
  GraphQLCreateSection _graphQLCreateSection = GraphQLCreateSection();
  GraphQLSection _graphQLSection = GraphQLSection();

  @override
  void initState() {
    super.initState();
    fetchToken();
      Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            EditSectionArguments('','',0)) as EditSectionArguments;
      });
    });
    fetchSectionData(args.section_id);
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            looping: false,
          );
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void fetchSectionData(String sectionId) async {
    var res = await _graphQLSection.sectionById(id: sectionId);
    if (res != null) {
      setState(() {
        section = res;
        _sectionNameController.text = section.section_name;
        _sectionContentController.text = section.section_content;
        _documents = section.files_array.map((file) => File(file)).toList();
        _videoController = VideoPlayerController.networkUrl(Uri.parse(section.video_id))
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoController,
                looping: false,
              );
            });
          });
      });
    }
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
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController,
              looping: false,
            );
          });
        });
      });
    }
  }
  void fetchToken() async {
    prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> jwtDecodedToken =
    JwtDecoder.decode(prefs.getString('token') as String);
    String userID = jwtDecodedToken['UserID'];
    setState(() {
      userId = userID;
    });
  }

  void _removeVideo() {
    setState(() {
      _videoFile = null;
      _videoController.dispose();
      _chewieController.dispose();
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

  void _saveSection() async {
    var res1 = await uploadFile(
      file: _videoFile!.readAsBytesSync(),
      file_name: 'video_${DateTime.now().millisecondsSinceEpoch}',
      data_type: _videoFile!.path.split('.').last,
      user_id: userId!,
      token: prefs.getString('token') as String,
    );
    
    List<Uint8List> files = _documents.map((document) => document.readAsBytesSync()).toList();
    List<String> file_names = _documents.map((document) => document.path.split('/').last).toList();
    List<String> res2 = [];
    try {
    for (int i = 0; i < files.length; i++) {
      var fileId = await uploadFile(
        file: files[i],
        file_name: file_names[i],
        data_type: _documents[i].path.split('.').last,
        user_id: userId!,
        token: prefs.getString('token') as String,
      );
      res2.add(fileId);
    }
  } catch (e) {
    print('Error: $e');
  }
    if(res1 != null && res2 != null) {
      print('Upload Success!');
      setState(() {
        section = SectionModel(
          section_id: '',
          section_name: _sectionNameController.text,
          section_content: _sectionContentController.text,
          video_id: res1,
          files_array: res2,
          pos_index: args.pos_index,
        );
      });
    } else {
      print('Error saving section');
    }
    var res3 = await _graphQLCreateSection.createSection(sectionModel: section, module_id: args.module_id);
    if(res3 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sección creada exitosamente'),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear la sección'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else{

  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Section'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              decoration: const InputDecoration(
                labelText: 'Section Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sectionContentController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Section Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _buildVideoSection(),
            const SizedBox(height: 20),
            _buildDocumentSection(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSection();
              },
              child: const Text('Guardar Sección'),
            ),
          ],
        ),
      ),
    );
  }
}
  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video Upload',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _videoFile != null
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _removeVideo,
                    icon: const Icon(Icons.remove_circle),
                    label: const Text('Remove Video'),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.video_library),
                label: const Text('Upload Video'),
              ),
      ],
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Documents',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
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
                        icon: const Icon(Icons.remove_circle),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickDocument,
          icon: const Icon(Icons.attach_file),
          label: const Text('Upload Document'),
        ),
      ],
    );
  }
}
