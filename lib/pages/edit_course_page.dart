import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/models/create_course_model.dart';
import 'package:leare_fa/models/image_model.dart';
import 'package:leare_fa/pages/course_page.dart';
import 'package:leare_fa/utils/graphq_edit_course.dart';
import 'package:leare_fa/utils/graphql_categories.dart';
import 'package:leare_fa/utils/image_utils.dart';
import 'package:leare_fa/utils/upload_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leare_fa/utils/graphql_course.dart';

class EditCoursePage extends StatefulWidget {
  final String course_id;
  const EditCoursePage({Key? key, this.course_id = ''}) : super(key: key);

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  ImageModel? img;
  bool isImageChanged = false;
  bool isLoading = true;
  late bool isPublic;
  String? userId;
  late CourseModel course;
  late SharedPreferences prefs;
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  List<CategoryModel> _categories = [];
  List<CategoryModel> _selectedCategories = [];
  final GraphQLCourse _graphQLCourse = GraphQLCourse();
  var args;

  @override
  void initState() {
    super.initState();
    fetchToken();
    fetchCategories();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            CourseArguments('')) as CourseArguments;
      });
      var courseId = args.course_id;
      if (courseId != '') {
        fetchCourseData(courseId);
      }
    });
  }

  void selectImage() async {
    ImageModel image = await pickImage(source: ImageSource.gallery);
    if (image.base64 == null) {
      return;
    }
    setState(() {
      img = image;
      isImageChanged = true;
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

  void fetchCourseData(String courseId) async {
    try {
      course = await _graphQLCourse.courseById(id: courseId);
      setState(() {
        _courseNameController.text = course.course_name;
        _courseDescriptionController.text = course.course_description;
        _selectedCategories = course.categories;
        isPublic =
            course.is_public; // Actualizar el estado del interruptor isPublic
        isLoading = false;
        print(isPublic);
      });
    } catch (error) {
      print("Error fetching course data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Curso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                    onTap: selectImage,
                    child: img == null
                        ? Image.network(
                            course.picture_id == "notFound"
                                ? 'https://www.inlinefs.com/wp-content/uploads/2020/04/placeholder.png'
                                : course.picture_id,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            img!.base64!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (isImageChanged)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            img = null;
                            isImageChanged = false;
                          });
                        },
                        child: const Text('Cancelar Cambios'),
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
                  // Switch para permitir al usuario elegir si el curso es público o no
                  // Row(
                  //   children: [
                  //     const Text('Curso Público: '),
                  //     Switch(
                  //       value: isPublic,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           isPublic = !isPublic;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  DropdownButtonFormField<CategoryModel>(
                    value: null,
                    hint: const Text('Elige las categorías del curso'),
                    onChanged: (newValue) {
                      if (newValue != null &&
                          !_selectedCategories.any((category) =>
                              category.category_id == newValue.category_id)) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
          ElevatedButton(
            onPressed: () async {
              var res;
              if (_courseNameController.text.isEmpty ||
                  _courseDescriptionController.text.isEmpty ||
                  _selectedCategories.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, completa todos los campos'),
                  ),
                );
                return;
              }

              if (img != null) {
                res = await uploadFile(
                    file: img!.base64!,
                    file_name: 'cp_${course.course_id}',
                    data_type: img!.file.split('.').last,
                    user_id: userId!,
                    token: prefs.getString('token')!);
              } else {
                res = course.picture_id;
              }
              print(isPublic);
              CreateCourseModel courseQ = CreateCourseModel(
                  course_id: course.course_id,
                  course_name: _courseNameController.text,
                  course_description: _courseDescriptionController.text,
                  categories:
                      _selectedCategories.map((e) => e.category_id).toList(),
                  picture_id: res,
                  is_public: isPublic,
                  chat_id: course.chat_id);
              var res2 = await GraphQLEditCourse()
                  .editCourse(createCourseModel: courseQ);
              if (res2 == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al editar el curso'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Curso editado correctamente'),
                  ),
                );
                Navigator.pushReplacementNamed(context, '/course',
                    arguments: CourseArguments(course.course_id));
              }
            },
            child: const Text('Editar Curso'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
