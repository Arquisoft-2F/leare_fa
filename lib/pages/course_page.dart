import 'package:flutter/material.dart';
import 'package:leare_fa/widgets/widgets.dart';

//Clase para recibir los argumentos
class CourseArguments {
  final String course_id;
  CourseArguments(this.course_id);
}
//Clase para recibir los argumentos

class CoursePage extends StatelessWidget {
  // Variables del fetch
  static const List<Map<String, String>> categories = [
    {"category_name": "Tecnología"},
    {"category_name": "Comedia"},
    {"category_name": "Actualidad"}
  ];
  static const String courseName = "Fundamentos de programación en Java";
  static const String description =
      "Embárcate en un emocionante viaje hacia el dominio de Java con nuestro curso online completo. Desde los fundamentos básicos hasta técnicas avanzadas, este curso te llevará de la mano a través de conceptos clave de programación, sintaxis de Java y prácticas recomendadas. Aprovecha nuestros recursos interactivos, proyectos prácticos y soporte personalizado mientras te sumerges en el fascinante mundo de la programación en Java. ¡Prepárate para desbloquear todo el potencial de esta poderosa y versátil tecnología!";
  static const String profilePic = "assets/profilepic.png";
  static const String nombre = "Santiago";
  static const String apellido = "Guerrero";
  static const String nickname = "sangue19";

  static const modules = [
    {
      "module_id": "e170423d-a00d-4a14-9e55-52eeb040263c",
      "module_name": "Modulo Archivos Prueba 1",
      "pos_index": 1,
      "sections": [
        {
          "section_id": "4090e588-733c-43c1-b774-b3816e478492",
          "section_name": "Seccion prueba archivos 1",
          "section_content": "Contenido de prueba",
          "video_id": "9974a9bf-a7dd-4939-bd79-2605dac685be",
          "files_array": [
            "4e05beba-001c-453a-a26e-992e06df094b",
            "08b5e473-7a5f-4fcb-9f8c-407936e49cdf",
            "57fb07e7-ffc8-4121-8782-43946d414c7f"
          ],
          "pos_index": 1
        },
        {
          "section_id": "cc9db30f-ca33-4bf2-96d2-5ac5dec9f033",
          "section_name": "Seccion prueba archivos 2",
          "section_content": "Contenido de prueba",
          "video_id": "1512fbc0-bdc0-4fbb-8a93-b65d10187ff6",
          "files_array": [
            "12af4764-19dc-4f5f-816d-b0e8730f4366",
            "f9ba812e-4678-4dca-86ee-583d7ca117e9"
          ],
          "pos_index": 2
        }
      ]
    },
    {
      "module_id": "dd9d471a-1b15-4e56-94a9-d426afe1d3f2",
      "module_name": "Modulo Archivos Prueba 2",
      "pos_index": 2,
      "sections": [
        {
          "section_id": "01e9e0f7-a22c-4161-9db5-ca08cc3ee2c5",
          "section_name": "Seccion prueba archivos 3",
          "section_content": "Contenido de prueba",
          "video_id": "524d2b66-daca-4788-878c-f6973da3610f",
          "files_array": [
            "d58ee832-cd27-43eb-a55b-e203b4842f75",
            "125816f6-6741-4805-b535-a7f82111b6bf"
          ],
          "pos_index": 1
        },
        {
          "section_id": "44f364c5-e5da-4ab6-a418-537478a26453",
          "section_name": "Seccion prueba archivos 3",
          "section_content": "Contenido de prueba",
          "video_id": "c708aeb3-c202-4154-8eb9-75de83c6d87a",
          "files_array": [
            "3821d57b-d97b-4037-8a06-9a75ab93e777",
            "55d985b6-fd0b-47c8-805b-c920ea6f48e4"
          ],
          "pos_index": 2
        }
      ]
    },
    {
      "module_id": "ad1f2051-4655-4bc1-9aec-094c19660e27",
      "module_name": "Modulo Archivos Prueba 3",
      "pos_index": 3,
      "sections": [
        {
          "section_id": "fa8e8992-3156-43d5-b9ed-2ea377d2a2f7",
          "section_name": "Seccion prueba archivos 5",
          "section_content": "Contenido de prueba",
          "video_id": "62873512-5852-4e13-86a7-a83d437317ac",
          "files_array": [
            "9851e57d-20af-421b-b003-64d2b876b8c0",
            "48bf7e86-1e65-4ccc-890d-e1adea2ba47a"
          ],
          "pos_index": 1
        },
        {
          "section_id": "26779b51-b613-43a0-bff7-b14eb4f8fc06",
          "section_name": "Seccion prueba archivos 6",
          "section_content": "Contenido de prueba",
          "video_id": "a3478b00-c74e-4049-ac0d-4ebe8d213626",
          "files_array": [
            "7d58a7da-1a63-4d64-b523-5e8188b1d724",
            "aaa6bed1-78eb-4726-8291-4cc98f63e4f1"
          ],
          "pos_index": 2
        }
      ]
    },
    {
      "module_id": "49f4429a-32b1-48df-a089-6ae7bd27ff3e",
      "module_name": "Modulo Archivos Prueba 4",
      "pos_index": 4,
      "sections": [
        {
          "section_id": "4d874eb2-dac7-4609-b932-82dc6be7cbab",
          "section_name": "Seccion prueba archivos 6",
          "section_content": "Contenido de prueba",
          "video_id": "a7a48104-1f1d-4b90-83aa-a8807380e61c",
          "files_array": [
            "5b5873d9-3ee4-450d-aafe-41a93fc263b7",
            "14cfc326-9c09-4d18-87ea-4e79c26675b7"
          ],
          "pos_index": 1
        },
        {
          "section_id": "308dd034-8a7f-4dfb-a114-82a3f548ce5e",
          "section_name": "Seccion prueba archivos 6",
          "section_content": "Contenido de prueba",
          "video_id": "47504a65-885e-4a2e-9577-4b6807d9f831",
          "files_array": [
            "f672d0fa-85d1-40e3-bffa-cda00e409232",
            "1b5fd96a-19b6-4b4d-b18a-0a561ac11a06"
          ],
          "pos_index": 2
        }
      ]
    },
    {
      "module_id": "4567ac92-c0f4-46ea-81d7-8a3dd29d56ef",
      "module_name": "Modulo Archivos Prueba 5",
      "pos_index": 5,
      "sections": []
    },
    {
      "module_id": "91f11dc6-2c69-4b2c-82d8-79b87dc03d09",
      "module_name": "Modulo Archivos Prueba 6",
      "pos_index": 6,
      "sections": []
    }
  ];
  static String moduleAmount = modules.length.toString();
  // Variables del fetch
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Recibir los argumentos del socio
    final args = ModalRoute.of(context)?.settings.arguments as CourseArguments;
    var courseId = args.course_id;
    // Recibir los argumentos del socio

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
                                    category['category_name'];
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
                            '$courseName $courseId',
                            style: const TextStyle(
                                height: 1.2,
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
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
                            child: Text('$moduleAmount modulos',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const ModuleAccordion(
                            moduleList: modules,
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
