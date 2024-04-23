import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/models/create_course_model.dart';
import 'package:leare_fa/models/image_model.dart';
import 'package:leare_fa/utils/graphql_categories.dart';
import 'package:leare_fa/utils/graphql_create_course.dart';
import 'package:leare_fa/utils/image_utils.dart';
import 'package:leare_fa/utils/upload_file.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCoursePage extends StatefulWidget {
  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  ImageModel? img;
  String? userId;
  late SharedPreferences prefs;
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  List<CategoryModel> _categories = [];
  List<CategoryModel> _selectedCategories = [];

  void initState() {
    super.initState();
    fetchToken();
    fetchCategories();
  }

  void selectImage() async {
    ImageModel image = await pickImage(source: ImageSource.gallery);
    if (image.base64 == null) {
      return;
    }
    setState(() {
      img = image;
    });
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

  void fetchCategories() async {
    var cats = await GraphQLCategories().getCategories();
    setState(() {
      _categories = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Curso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width *
              (Responsive.isDesktop(context) ? 0.5 : 0.9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: img == null
                            ? Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Image.memory(
                                img!.base64!,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _courseNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Curso',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _courseDescriptionController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Descripción del Curso',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<CategoryModel>(
                        value: null,
                        hint: const Text('Elige las categorías del curso'),
                        onChanged: (newValue) {
                          if (newValue != null &&
                              !_selectedCategories.contains(newValue)) {
                            setState(() {
                              _selectedCategories.add(newValue);
                            });
                          }
                        },
                        items: _categories.map((CategoryModel value) {
                          return DropdownMenuItem<CategoryModel>(
                            value: value,
                            child: Text(value.category_name),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        children: _selectedCategories.map((category) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Chip(
                              label: Text(category.category_name),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_courseNameController.text.isEmpty ||
                      _courseDescriptionController.text.isEmpty ||
                      _selectedCategories.isEmpty ||
                      img == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, completa todos los campos'),
                      ),
                    );
                    return; // No continúes si algún campo está vacío
                  }

                  var res = await uploadFile(
                      file: img!.base64!,
                      file_name: 'pp_$userId',
                      data_type: img!.file.split('.').last,
                      user_id: userId!,
                      token: prefs.getString('token')!);
                  CreateCourseModel course = CreateCourseModel(
                    course_name: _courseNameController.text,
                    course_description: _courseDescriptionController.text,
                    categories:
                        _selectedCategories.map((e) => e.category_id).toList(),
                    picture_id: res,
                  );
                  var res2 = await GraphQLCreateCourse()
                      .createCourse(createCourseModel: course);
                  if (res2 == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al crear el curso'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Curso $res2 creado correctamente'),
                      ),
                    );
                    // Navigator.pop(context, course);
                  }
                },
                child: const Text('Crear Curso'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
