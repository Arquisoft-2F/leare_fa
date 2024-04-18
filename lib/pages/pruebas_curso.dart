import 'package:flutter/material.dart';
import 'package:leare_fa/pages/course_page.dart';

class PruebasCurso extends StatelessWidget {
  const PruebasCurso({super.key});

  @override
  Widget build(BuildContext context) {
    var courseId = "34d207bc-cb98-4b25-86a1-55b5db19a354";
    return Scaffold(
      body: Container(
        child: ElevatedButton(
          child: const Text('Entrar a curso'),
          onPressed: () {
            Navigator.pushNamed(context, '/course',
                arguments: CourseArguments(courseId));
          },
        ),
      ),
    );
  }
}