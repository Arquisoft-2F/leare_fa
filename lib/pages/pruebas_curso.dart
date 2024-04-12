import 'package:flutter/material.dart';
import 'package:leare_fa/pages/course_page.dart';

class PruebasCurso extends StatelessWidget {
  const PruebasCurso({super.key});

  @override
  Widget build(BuildContext context) {
    var courseId = "1000";
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
