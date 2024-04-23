import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/pages/create_section_page.dart';
import 'package:leare_fa/pages/edit_section_page.dart';
import 'package:leare_fa/pages/pages.dart';

class ModuleAccordion extends StatelessWidget {
  final List<ModuleModel> moduleList;
  final String course_id;

  const ModuleAccordion(
      {Key? key, required this.moduleList, required this.course_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Accordion(
      disableScrolling: true,
      headerBorderColor: Theme.of(context).colorScheme.primaryContainer,
      headerBorderColorOpened: Theme.of(context).colorScheme.inversePrimary,
      // headerBorderWidth: 1,
      headerBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
      headerBackgroundColorOpened:
          Theme.of(context).colorScheme.inversePrimary,
      contentBackgroundColor:
          Theme.of(context).colorScheme.surfaceVariant,
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
              children: [
                Text(moduleName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Acción de edición del módulo
                  },
                ),
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
                      children: [
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
                            Navigator.pushNamed(context, '/editSection',
                                arguments: EditSectionArguments(
                                    section.section_id!, module.module_id, section.pos_index));
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createSection', arguments: CreateSectionArguments(module.module_id, module.sections.length));
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Create New Section',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
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
