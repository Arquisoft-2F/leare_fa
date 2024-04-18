import 'package:flutter/material.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/utils/graphql_course.dart';

//Clase para recibir los argumentos
class CourseArguments {
  final String course_id;
  CourseArguments(this.course_id);
}
//Clase para recibir los argumentos

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // static String moduleAmount = modules.length.toString();
  bool isLoading = true;
  late CourseModel course;
  final GraphQLCourse _graphQLCourse = GraphQLCourse();

  static const String profilePic = "assets/profilepic.png";
  static const String nombre = "Santiago";
  static const String apellido = "Guerrero";
  static const String nickname = "sangue19";

  // @override
  // void initState() {
  //   super.initState();
  //   print("Pase al init");
  //   // fetchCourseData();
  // }

  void fetchCourseData(String courseId) async {
    try {
      print("Entre a fetch course");
      print(courseId);
      course = await _graphQLCourse.courseById(id: courseId);
      setState(() {
        course = course;
      });
    } catch (error) {
      print("Error fetching course data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recibir los argumentos del socio
    // final args = (ModalRoute.of(context)?.settings.arguments ??
    //     CourseArguments('')) as CourseArguments;
    // var courseId = args.course_id;
    // Recibir los argumentos del socio
    final args = (ModalRoute.of(context)?.settings.arguments ??
        CourseArguments('')) as CourseArguments;
    var courseId = args.course_id;
    fetchCourseData(courseId);
    var categories = course.categories;
    var description = course.course_description;

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
              child: SafeArea(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6),
                            BlendMode.darken,
                          ),
                          child: Image.asset(
                            'assets/imagen-curso.png',
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
                                    size: 35,
                                  )),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1.0),
                                        size: 35,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1.0),
                                        size: 40,
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
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
                          const InstructorBadge(
                            profilePic: profilePic,
                            nombre: nombre,
                            apellido: apellido,
                            nickname: nickname,
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
                          const SizedBox(
                            height: 10,
                          ),
                          ModuleAccordion(
                            moduleList: course.modules,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
