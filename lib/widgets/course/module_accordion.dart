import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class ModuleAccordion extends StatelessWidget {
  final moduleList;
  static const listaPrueba = ['1', '2', '3'];
  const ModuleAccordion({super.key, required this.moduleList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Accordion(
        disableScrolling: true,
        headerBorderColor: const Color(0xffd3e4ff),
        headerBorderColorOpened: const Color(0xffd3e4ff),
        // headerBorderWidth: 1,
        headerBackgroundColor: const Color.fromARGB(255, 106, 162, 252),
        headerBackgroundColorOpened: const Color.fromARGB(255, 177, 206, 254),
        contentBackgroundColor: const Color(0xffdfe2eb),
        contentBorderColor: const Color(0xffdfe2eb),
        contentBorderWidth: 3,
        contentHorizontalPadding: 10,
        scaleWhenAnimating: true,
        openAndCloseAnimation: true,
        headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        rightIcon: const Icon(Icons.keyboard_arrow_down,
            color: Colors.black, size: 30),
        contentVerticalPadding: 10,
        children: moduleList.map<AccordionSection>((module) {
          var moduleName = module['module_name'];
          var sections = module['sections'];
          return AccordionSection(
              isOpen: false,
              header: Text(moduleName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              content: Column(
                children: sections.map<Padding>((section) {
                  var sectionName = section['section_name'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      sectionName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  );
                }).toList(),
              ));
        }).toList(),
      ),
    );
  }
}
