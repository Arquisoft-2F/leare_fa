import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:leare_fa/utils/graphql_section.dart';
// import 'package:leare_fa/widgets/section/section_tabs.dart';

class SectionArguments {
  final String section_id;
  final wholeSections;
  SectionArguments(this.section_id, this.wholeSections);
}

class SectionPage extends StatefulWidget {
  final String section_id;
  final wholeSections;
  const SectionPage({super.key, this.section_id = '', this.wholeSections});

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  late SectionModel section = SectionModel(
      section_id: '',
      section_name: '',
      section_content: '',
      video_id: '',
      files_array: [],
      pos_index: 0);

  var args;
  String video_id = '';

  final GraphQLSection _graphQLSection = GraphQLSection();

  void initState() {
    super.initState();
    print("Pase al init");
    Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            SectionArguments('', [])) as SectionArguments;
      });
      print(args);
      var sectionId = args.section_id;
      print("SectionId es:");
      print(sectionId);
      if (sectionId != '') {
        fetchSectionData(sectionId);
      }
      // print("Id usuario:");
      // print(user_id);
      // fetchUserData(user_id);
    });
  }

  void fetchSectionData(String sectionId) async {
    try {
      print("Entre a fetch section");
      print(sectionId);
      section = await _graphQLSection.sectionById(id: sectionId);
      setState(() {
        section = section;
      });
      setState(() {
        video_id = section.video_id;
      });
    } catch (error) {
      print("Error fetching section data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = (ModalRoute.of(context)?.settings.arguments ??
          SectionArguments('', [])) as SectionArguments;
    });

    var contenido = section.section_content;
    var sectionName = section.section_name;
    var recursos = section.files_array;
    print("video id es:");
    print(video_id);

    var secciones = args.wholeSections;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  SectionVideo(videoUrl: video_id),
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
