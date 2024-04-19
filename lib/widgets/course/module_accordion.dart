import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/pages/pages.dart';

class ModuleAccordion extends StatelessWidget {
  final List<ModuleModel> moduleList;
  static const listaPrueba = ['1', '2', '3'];
  const ModuleAccordion({super.key, required this.moduleList});

  @override
  Widget build(BuildContext context) {
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
        return AccordionSection(
            isOpen: false,
            header: Text(moduleName,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            content: Column(
              children: sections.map<Padding>((section) {
                var sectionName = section.section_name;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/section',
                          arguments: SectionArguments(
                              section.section_id,
                              section.section_name,
                              section.section_content,
                              section.video_id,
                              section.files_array,
                              section.pos_index,
                              module.sections));
                    },
                    child: Text(
                      sectionName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                );
              }).toList(),
            ));
      }).toList(),
    );
  }
}
