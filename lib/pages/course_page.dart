import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:leare_fa/utils/delete/graphql_deleteCourses.dart';
import 'package:leare_fa/utils/graphql_create_module.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/utils/graphql_course.dart';
import 'package:leare_fa/utils/graphql_user.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseArguments {
  final String course_id;
  CourseArguments(this.course_id);
}

class CoursePage extends StatefulWidget {
  final String course_id;
  const CoursePage({super.key, this.course_id = ''});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isLoading = true;
  late CourseModel course;
  late UserModel user;
  final GraphQLUser _graphQLUser = GraphQLUser();
  final GraphQLCourse _graphQLCourse = GraphQLCourse();
  final GraphQLCreateModule _graphQLCreateModule = GraphQLCreateModule();
  final GraphQLDeletes _graphQLDelete = GraphQLDeletes();
  late UserModel creatorCourse;
  String user_id = '';
  late SharedPreferences prefs;
  var args;

  TextEditingController _moduleNameController =
      TextEditingController(); // Controlador de texto para el nombre del módulo

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            CourseArguments('')) as CourseArguments;
      });
      var courseId = args.course_id;
      fetchMyToken();
      if (courseId != '') {
        fetchCourseData(courseId);
      }
    });
  }

  void fetchCourseData(String courseId) async {
    try {
      course = await _graphQLCourse.courseById(id: courseId);
      setState(() {
        course = course;
      });
      setState(() {
        user_id = course.creator_id;
      });
      fetchUserData(user_id);
    } catch (error) {
      print("Error fetching course data: $error");
    }
  }

  void fetchMyToken() async {
    try {
      prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> jwtDecodedToken =
          JwtDecoder.decode(prefs.getString('token') as String);
      String userID = jwtDecodedToken['UserID'];
      setState(() {
        creatorCourse = UserModel(
            id: jwtDecodedToken['UserID'],
            name: "",
            lastname: "",
            nickname: jwtDecodedToken['Username'],
            email: "",
            nationality: "");
      });
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  void fetchUserData(String user_id) async {
    try {
      user = await _graphQLUser.userbyId(id: user_id);
      setState(() {
        user = user;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  // Función para abrir el modal
  void _openModuleModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingresa nombre del modulo'),
          content: TextField(
            controller: _moduleNameController,
            decoration: const InputDecoration(hintText: 'Nombre del módulo'),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Código para crear o editar el módulo aquí
                    String moduleName = _moduleNameController.text;
                    var res1 = await _graphQLCreateModule.createModule(
                        module_name: moduleName,
                        course_id: course.course_id,
                        pos_index: course.modules.length);
                    if (res1 != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Módulo creado exitosamente'),
                        ),
                      );
                      fetchCourseData(course.course_id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al crear el módulo'),
                        ),
                      );
                    }
                    Navigator.of(context).pop(); // Cierra el modal
                  },
                  child: const Text('Guardar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el modal sin guardar
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      var categories = course.categories;
      var description = course.course_description;
      var pictureUrl = course.picture_id == "notFound"
          ? 'https://www.inlinefs.com/wp-content/uploads/2020/04/placeholder.png'
          : course.picture_id;
      var profilePic = user.picture_id == "n/a"
          ? 'https://www.inlinefs.com/wp-content/uploads/2020/04/placeholder.png'
          : user.picture_id;

      return Scaffold(
        backgroundColor: const Color(0xfff8f9ff),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.chat),
          onPressed: () {},
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6),
                            BlendMode.darken,
                          ),
                          child: Image.network(
                            pictureUrl,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 24,
                                ),
                              ),
                              Row(
                                children: [
                                  PopupMenuButton(
                                    color: Colors.white,
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                      size: 29,
                                    ),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      creatorCourse.id == user.id
                                          ? PopupMenuItem(
                                              child: const Text('Editar curso'),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/editCourse',
                                                    arguments: CourseArguments(
                                                        args.course_id));
                                              },
                                            )
                                          : const PopupMenuItem(
                                              enabled: false,
                                              child: Text('Editar curso'),
                                            ),
                                      PopupMenuItem(
                                        enabled: creatorCourse.id == user.id
                                            ? true
                                            : false,
                                        child: const Text('Eliminar curso'),
                                        onTap: () async {
                                          bool res = await _graphQLDelete
                                              .deleteCourse(course.course_id);
                                          if (res) {
                                            Navigator.pushNamed(
                                                context, '/home');
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Eliminación de curso no exitosa'),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: const Text(''),
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              spacing: 10,
                              children: categories.map((category) {
                                final String? categoryName =
                                    category.category_name;
                                return CategoryBadge(
                                    category_name: categoryName);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Column(
                        children: [
                          Text(
                            course.course_name,
                            style: const TextStyle(
                                height: 1.2,
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            description,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                height: 1.2,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                          const LineSeparator(),
                          InstructorBadge(
                            profilePic: profilePic,
                            nombre: user.name,
                            apellido: user.lastname,
                            nickname: user.nickname,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const LineSeparator(),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                                '${course.modules.length.toString()} modulos',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                          ModuleAccordion(
                              moduleList: course.modules,
                              course_id: course.course_id,
                              update: fetchCourseData,
                              author: creatorCourse.id == course.creator_id),
                          TextButton.icon(
                            onPressed: _openModuleModal, // Abre el modal
                            icon: const Icon(Icons.add),
                            label: const Text('Añadir módulo'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
