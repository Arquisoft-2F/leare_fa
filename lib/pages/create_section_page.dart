import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/utils/graphq_create_section.dart';
import 'package:leare_fa/utils/upload_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class CreateSectionArguments {
  final String module_id;
  final int pos_index;
  CreateSectionArguments(this.module_id, this.pos_index);
}

class CreateSectionPage extends StatefulWidget {
  final String module_id;
  final int pos_index;

  const CreateSectionPage({super.key, this.module_id = '', this.pos_index = 0});
  
  @override
  _CreateSectionPageState createState() => _CreateSectionPageState();
}

class _CreateSectionPageState extends State<CreateSectionPage> {
  late SharedPreferences prefs;
  SectionModel section = SectionModel(
    section_id: '',
    section_name: '',
    section_content: '',
    video_id: '',
    files_array: [],
    pos_index: 0,
  );
  String? userId;
  Uint8List? videoBytes;
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  bool isLoadingVideo = true;
  File? _videoFile;
  List<File>? _documents = [];
  List<Uint8List>? _documentsBytes = [];
  TextEditingController _sectionNameController = TextEditingController();
  TextEditingController _sectionContentController = TextEditingController();
  var args;
  GraphQLCreateSection _graphQLCreateSection = GraphQLCreateSection();

  @override
  void initState() {
    super.initState();
    fetchToken();
        Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            CreateSectionArguments('',0)) as CreateSectionArguments;
      });
    });
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            looping: false,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _pickVideoM() async {
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
            isLoadingVideo = false;
          });
        });
      });
    }
  }

    Future<void> _pickVideoW() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      var file = result.files.single.bytes;
      setState(() {
        videoBytes = file;
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
      isLoadingVideo = true;
    });
  }

  void _removeVideoW() {
    setState(() {
      videoBytes = null;
    });
  }

  Future<void> _pickDocumentM() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _documents!.add(file);
      });
    }
  }

   Future<void> _pickDocumentW() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      var file = result.files.single.bytes;
      setState(() {
        _documentsBytes!.add(file!);
      });
    }
  }

  void _removeDocument(File document) {
    setState(() {
      _documents!.remove(document);
    });
  }

    void _removeDocumentW(Uint8List document) {
    setState(() {
      _documentsBytes!.remove(document);
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

    List<Uint8List> files = _documents!.map((document) => document.readAsBytesSync()).toList();
    List<String> file_names = _documents!.map((document) => document.path.split('/').last).toList();
    List<String> res2 = [];
    try {
    for (int i = 0; i < files.length; i++) {
      var fileId = await uploadFile(
        file: files[i],
        file_name: file_names[i],
        data_type: _documents![i].path.split('.').last,
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

    void _saveSectionW() async {
    var res1 = await uploadFile(
      file: videoBytes!,
      file_name: 'video_${DateTime.now().millisecondsSinceEpoch}',
      data_type: 'mp4',
      user_id: userId!,
      token: prefs.getString('token') as String,
    );

    List<Uint8List> files = _documentsBytes!;
    List<String> file_names = _documentsBytes!.map((document) => 'document_${const Uuid().v4()}').toList();
    List<String> res2 = [];
    try {
    for (int i = 0; i < files.length; i++) {
      var fileId = await uploadFile(
        file: files[i],
        file_name: file_names[i],
        data_type: _documents![i].path.split('.').last,
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
    if(Platform.isAndroid){
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
            _buildVideoSectionW(),
            const SizedBox(height: 20),
            _buildDocumentSectionW(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSectionW();
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
                    child: isLoadingVideo
                        ? const Center(child: CircularProgressIndicator())
                        :
                    Chewie(
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
                onPressed: _pickVideoM,
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
          children: _documents!
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
          onPressed: _pickDocumentM,
          icon: const Icon(Icons.attach_file),
          label: const Text('Upload Document'),
        ),
      ],
    );
  }

  Widget _buildVideoSectionW() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video Upload',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        videoBytes != null
            ? Column(
                children: [
                  const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Icon(
                      Icons.videocam,
                      size: 100,
                      color: Colors.grey,
                    )
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _removeVideoW,
                    icon: const Icon(Icons.remove_circle),
                    label: const Text('Remove Video'),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: _pickVideoW,
                icon: const Icon(Icons.video_library),
                label: const Text('Upload Video'),
              ),
      ],
    );
  }

  Widget _buildDocumentSectionW() {
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
          children: _documentsBytes!
              .map(
                (document) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(child: Text("Document ${_documentsBytes!.indexOf(document)}")),
                      IconButton(
                        onPressed: () => _removeDocumentW(document),
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
          onPressed: _pickDocumentW,
          icon: const Icon(Icons.attach_file),
          label: const Text('Upload Document'),
        ),
      ],
    );
  }
}
