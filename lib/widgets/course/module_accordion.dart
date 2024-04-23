import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/pages/create_section_page.dart';
import 'package:leare_fa/pages/edit_section_page.dart';
import 'package:leare_fa/pages/pages.dart';
import 'package:leare_fa/utils/delete/graphql_deleteCourses.dart';

class ModuleAccordion extends StatelessWidget {
  final List<ModuleModel> moduleList;
  final String course_id;
  final bool author;
  final void Function(String courseId) update;
  final bool enrollmentState;

  const ModuleAccordion(
      {Key? key,
      required this.moduleList,
      required this.course_id,
      required this.author,
      required void Function(String courseId) this.update,
      required this.enrollmentState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GraphQLDeletes _graphQLDelete = GraphQLDeletes();
    return Accordion(
      disableScrolling: true,
      headerBorderColor: Theme.of(context).colorScheme.primaryContainer,
      headerBorderColorOpened: Theme.of(context).colorScheme.inversePrimary,
      // headerBorderWidth: 1,
      headerBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
      headerBackgroundColorOpened: Theme.of(context).colorScheme.inversePrimary,
      contentBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      contentBorderColor: Theme.of(context).colorScheme.surfaceVariant,
      contentBorderWidth: 3,
      contentHorizontalPadding: 10,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      rightIcon: Icon(Icons.keyboard_arrow_down,
          color: Theme.of(context).colorScheme.onPrimaryContainer, size: 30),
      contentVerticalPadding: 10,
      children: moduleList.map<AccordionSection>((module) {
        var moduleName = module.module_name;
        var sections = module.sections;
        sections.sort((a, b) => a.pos_index.compareTo(b.pos_index));
        print(sections);
        return AccordionSection(
            isOpen: false,
            header: Row(
              children: author
                  ? [
                      Text(moduleName,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Acción de edición del módulo
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool res = await _graphQLDelete
                              .deleteModule(module.module_id);
                          if (res) {
                            moduleList.remove(module);
                            update(course_id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Eliminación de modulo no exitosa'),
                              ),
                            );
                          }
                        },
                      ),
                    ]
                  : [
                      Text(moduleName,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
            ),
            content: Column(
              children: [
                ...sections.map<Padding>((section) {
                  var sectionName = section.section_name;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: author
                          ? [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/section',
                                      arguments: SectionArguments(
                                          section.section_id!,
                                          module.sections,
                                          course_id));
                                },
                                child: Text(
                                  sectionName,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  print(
                                      "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                                  print(section.section_id!);
                                  Navigator.pushNamed(context, '/editSection',
                                      arguments: EditSectionArguments(
                                          section.section_id!,
                                          module.module_id,
                                          section.pos_index));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (section.section_id != null) {
                                    print(section.section_id);
                                    bool res = await _graphQLDelete
                                        .deleteSection(section.section_id!);
                                    if (res) {
                                      sections.remove(section);
                                      update(course_id);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Eliminación de sección no exitosa'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ]
                          : [
                              ElevatedButton(
                                onPressed: enrollmentState
                                    ? () {
                                        Navigator.pushNamed(context, '/section',
                                            arguments: SectionArguments(
                                                section.section_id!,
                                                module.sections,
                                                course_id));
                                      }
                                    : () {},
                                child: Text(
                                  sectionName,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                    ),
                  );
                }).toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/createSection',
                          arguments: CreateSectionArguments(module.module_id,
                              module.sections.length, course_id));
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Create New Section',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ));
      }).toList(),
    );
  }
}
