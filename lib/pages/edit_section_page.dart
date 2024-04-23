import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/pages/course_page.dart';
import 'package:leare_fa/utils/graphq_create_section.dart';
import 'package:leare_fa/utils/graphq_edit_section.dart';
import 'package:leare_fa/utils/graphql_section.dart';
import 'package:leare_fa/utils/upload_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';
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
  bool isLoadingVideo = true;
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  File? _videoFile;
  Uint8List? videoBytes;
  List<File>? _documents = [];
  List<Uint8List>? _documentsBytes = [];
  TextEditingController _sectionNameController = TextEditingController();
  TextEditingController _sectionContentController = TextEditingController();
  var args;
  GraphQLEditSection _graphQLEditSection = GraphQLEditSection();
  GraphQLSection _graphQLSection = GraphQLSection();

  @override
  void initState() {
    super.initState();
    fetchToken();
      Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            EditSectionArguments('','',0)) as EditSectionArguments;
        var sectionId = args.section_id;
        if(Platform.isAndroid){
            if (sectionId != '') {
            fetchSectionData(sectionId);
          }
        }
        else{
          if (sectionId != '') {
          fetchSectionDataW(sectionId);
        }
        }

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
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmovil");
    print(res.video_id);
    if (res != null) {
      setState(() {
        section = res;
        _sectionNameController.text = section.section_name;
        _sectionContentController.text = section.section_content;
        _documents = section.files_array.map((file) => File(file)).toList();
        if(section.video_id != '' || section.video_id != 'NotFound'){
        _videoFile = File(section.video_id);
        }
        else{
        _videoFile = null;
        }

        _videoController = VideoPlayerController.networkUrl(Uri.parse(_videoFile!.path));
        _videoController.initialize().then((_) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController,
              looping: false,
            );
            isLoadingVideo = false;
            isLoading = false;
          });
          });
      });
    }
  }
  void fetchSectionDataW(String sectionId) async {
    var res = await _graphQLSection.sectionById(id: sectionId);
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAweb");
    print(res.section_name);
    getWebFiles();
    if (res != null) {
      setState(() {
        section = res;
        _sectionNameController.text = section.section_name;
        _sectionContentController.text = section.section_content;
        _videoController = VideoPlayerController.networkUrl(Uri.parse(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            looping: false,
          );
          isLoading = false;
        });
      });
      });
    }
  }
  void getWebFiles() async {
    // Lee bytes para documentos y video
    var documentBytesFutures = section.files_array.map((file) async {
      if (file.endsWith('.mp4') || file.endsWith('.avi') || file.endsWith('.mkv')) {
        return await readVideoBytes(Uri.parse(file));
      } else {
        return await readDocumentBytes(Uri.parse(file));
      }
    }).toList();
    var documentBytes = await Future.wait(documentBytesFutures);
    setState(() {
      _documentsBytes = documentBytes;
    });
    if (section.video_id != '' && section.video_id != 'NotFound') {
      var videoBytes = await readVideoBytes(Uri.parse(section.video_id));
      setState(() {
        videoBytes = videoBytes;
      });
    } else {
      setState(() {
        videoBytes = null;
      });
    }
  }
  // Función para leer bytes de un documento
    Future<Uint8List> readDocumentBytes(Uri uri) async {
      HttpClientRequest request = await HttpClient().getUrl(uri);
    request.headers.set(HttpHeaders.accessControlAllowOriginHeader, '*'); // Puedes ajustar según tus necesidades
    request.headers.set(HttpHeaders.accessControlAllowCredentialsHeader, 'true'); // Habilita las credenciales del navegador
      HttpClientResponse response = await request.close();
      List<int> bytes = await consolidateHttpClientResponseBytes(response);
      return Uint8List.fromList(bytes);
    }

// Función para leer bytes de un video
    Future<Uint8List> readVideoBytes(Uri uri) async {
      HttpClientRequest request = await HttpClient().getUrl(uri);
      HttpClientResponse response = await request.close();
      List<int> bytes = await consolidateHttpClientResponseBytes(response);
      return Uint8List.fromList(bytes);
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
    var videoBytes = await readBytes(Uri.parse(_videoFile!.path));
    var res1 = await uploadFile(
      file: videoBytes,
      file_name: 'video_${DateTime.now().millisecondsSinceEpoch}',
      data_type: _videoFile!.path.split('.').last,
      user_id: userId!,
      token: prefs.getString('token') as String,
    );
    
    List<Future<Uint8List>> filesF = _documents!.map((document) async {
    try {
      return await document.readAsBytes();
    } catch (e) {
      return await readBytes(Uri.parse(document.path));
    }
    }).toList();

    List<Uint8List> files = await Future.wait(filesF);
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
          section_id: args.section_id,
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
    var res3 = await _graphQLEditSection.editSection(sectionModel: section, module_id: args.module_id);
    if(res3 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sección editar exitosamente'),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al editar la sección'),
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
    List<String> file_names = _documentsBytes!
        .map((document) => 'document_${const Uuid().v4()}')
        .toList();
    List<String> res2 = [];
    try {
      for (int i = 0; i < files.length; i++) {
        var fileId = await uploadFile(
          file: files[i],
          file_name: file_names[i],
          data_type: "document",
          user_id: userId!,
          token: prefs.getString('token') as String,
        );
        res2.add(fileId);
      }
    } catch (e) {
      print('Error: $e');
    }
    if (res1 != null && res2 != null) {
      print('Upload Success!');
      setState(() {
        section = SectionModel(
          section_id: args.section_id,
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
    var res3 = await _graphQLEditSection.editSection(
        sectionModel: section, module_id: args.module_id);
    if (res3 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sección editada exitosamente'),
        ),
      );

      Navigator.pushReplacementNamed(context, '/course',
          arguments: CourseArguments(args.course_id));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al editar la sección'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid){
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
        title: const Text('Editar Sección'),
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
              child: const Text('Editar Sección'),
            ),
          ],
        ),
      ),
    );
  }
  }
  else{
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Sección'),
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
                      aspectRatio: 4 / 3,
                      child: Icon(
                        Icons.videocam,
                        size: 100,
                        color: Colors.grey,
                      )),
                  Text('Video ${videoBytes!.length} bytes'),
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
                      Expanded(
                          child: Text(
                              "Document ${_documentsBytes!.indexOf(document)}")),
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
