import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/pages/course_page.dart';
import 'package:leare_fa/widgets/widgets.dart';
import 'package:leare_fa/utils/graphql_section.dart';
// import 'package:leare_fa/widgets/section/section_tabs.dart';

class SectionArguments {
  final String section_id;
  final wholeSections;
  final String course_id;
  SectionArguments(this.section_id, this.wholeSections, this.course_id);
}

class SectionPage extends StatefulWidget {
  final String section_id;
  final wholeSections;
  const SectionPage({super.key, this.section_id = '', this.wholeSections});

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  bool isLoading = true;
  late SectionModel section = SectionModel(
      section_id: '',
      section_name: '',
      section_content: '',
      video_id: '',
      files_array: [],
      pos_index: 0);

  var args;
  String video_id = '';
  Map<String, int> sectionIndexMap = {};
  final GraphQLSection _graphQLSection = GraphQLSection();

  int currentSection = -1;
  int prevSection = -1;
  int nextSection = -1;

  void initState() {
    super.initState();
    print("Pase al init");
    Future.delayed(Duration.zero, () {
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            SectionArguments('', [], '')) as SectionArguments;
      });

      var sectionId = args.section_id;

      for (int i = 0; i < args.wholeSections.length; i++) {
        sectionIndexMap[args.wholeSections[i].section_id] = i;
      }

      if (sectionId != '') {
        fetchSectionData(sectionId);
      }

      currentSection = findIndexBySectionId(sectionId)!;
      prevSection = findPreviousSectionIndex(currentSection);
      nextSection = findNextSectionIndex(currentSection);
    });
  }

  void fetchSectionData(String sectionId) async {
    try {
      print("Entre a fetch section");
      print(sectionId);
      section = await _graphQLSection.sectionById(id: sectionId);
      print(section.video_id);
      setState(() {
        section = section;
        video_id = section.video_id;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching section data: $error");
    }
  }

  int? findIndexBySectionId(String sectionId) {
    return sectionIndexMap[sectionId];
  }

  int findNextSectionIndex(int currentIndex) {
    if (currentIndex < args.wholeSections.length - 1) {
      return currentIndex + 1;
    }
    return -1; // Indicates no next section
  }

  int findPreviousSectionIndex(int currentIndex) {
    if (currentIndex > 0) {
      return currentIndex - 1;
    }
    return -1;
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
      setState(() {
        args = (ModalRoute.of(context)?.settings.arguments ??
            SectionArguments('', [], '')) as SectionArguments;
      });

      var contenido = section.section_content;
      var sectionName = section.section_name;
      var recursos = section.files_array;
      print("video id es:");
      print(video_id);

      Color iconColorNext = nextSection == -1 ? Colors.black12 : Colors.blue;
      Color iconColorPrev = prevSection == -1 ? Colors.black12 : Colors.blue;

      return Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    SectionVideo(videoUrl: video_id),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
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
                                    size: 20,
                                  )),
                            ),
                          ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                var currentSection =
                                    findIndexBySectionId(args.section_id);
                                var prevSection =
                                    findPreviousSectionIndex(currentSection!);
                                if (prevSection != -1) {
                                  Navigator.pushNamed(context, '/section',
                                      arguments: SectionArguments(
                                          args.wholeSections[prevSection]
                                              .section_id,
                                          args.wholeSections,
                                          args.course_id));
                                } else {
                                  print('No hay anterior');
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                                color: iconColorPrev,
                              )),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/course',
                                    arguments: CourseArguments(args.course_id));
                              },
                              icon: const Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.blueAccent,
                              )),
                          IconButton(
                              onPressed: () {
                                if (nextSection != -1) {
                                  Navigator.pushNamed(context, '/section',
                                      arguments: SectionArguments(
                                          args.wholeSections[nextSection]
                                              .section_id,
                                          args.wholeSections,
                                          args.course_id));
                                } else {
                                  print('No hay siguiente');
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 30,
                                color: iconColorNext,
                              ))
                        ]))
              ],
            ),
          ),
        ),
      );
    }
  }
}
