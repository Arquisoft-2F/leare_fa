import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leare_fa/widgets/widgets.dart';
// import 'package:leare_fa/widgets/section/section_tabs.dart';

class SectionArguments {
  final String section_id;
  final String section_name;
  final String section_content;
  final String video_id;
  final List<String> files_array;
  final int pos_index;
  SectionArguments(this.section_id, this.section_name, this.section_content,
      this.video_id, this.files_array, this.pos_index);
}

class SectionPage extends StatefulWidget {
  final String section_id;
  final String section_name;
  final String section_content;
  final String video_id;
  final List<String> files_array;
  final int pos_index;
  const SectionPage({
    super.key,
    this.section_id = '',
    this.section_name = '',
    this.section_content = '',
    this.video_id = '',
    required this.files_array,
    this.pos_index = 0,
  });

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  // String sectionName = '¿Qué es Java?';
  // String contenido =
  //     'Java es un poderoso lenguaje de programación de propósito general que se destaca por su portabilidad, seguridad y facilidad de uso. Con una sintaxis similar a C++, Java es conocido por su capacidad para desarrollar aplicaciones de escritorio, móviles y web, así como para la creación de aplicaciones empresariales y sistemas embebidos. Su enfoque en la programación orientada a objetos y su amplia variedad de bibliotecas lo convierten en una opción popular para desarrolladores de todo el mundo. Java es un poderoso lenguaje de programación de propósito general que se destaca por su portabilidad, seguridad y facilidad de uso. Con una sintaxis similar a C++, Java es conocido por su capacidad para desarrollar aplicaciones de escritorio, móviles y web, así como para la creación de aplicaciones empresariales y sistemas embebidos. Su enfoque en la programación orientada a objetos y su amplia variedad de bibliotecas lo convierten en una opción popular para desarrolladores de todo el mundo.';
  var args;
  // List<String> recursos = [
  //   'recurso1.pdf',
  //   'recurso2.pdf',
  //   'recurso3.java',
  //   'recurso4.py'
  // ];

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = (ModalRoute.of(context)?.settings.arguments ??
          SectionArguments('', '', '', '', [], 0)) as SectionArguments;
    });

    var contenido = args.section_content;
    var sectionName = args.section_name;
    var recursos = args.files_array;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  const SectionVideo(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 35,
                                )),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 40,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Color.fromRGBO(255, 255, 255, 1.0),
                                  size: 40,
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              TabsSection(
                content: contenido,
                resources: recursos,
                sectionName: sectionName,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_ios, size: 30)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios, size: 30))
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
