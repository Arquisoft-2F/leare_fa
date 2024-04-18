import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leare_fa/models/models.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // final Map<String, String> course = {
    //   "course_id": "d72aa1f5-d20e-48a2-9e52-935da05ebd1b",
    //   "course_name": "Demo",
    //   "course_description": "Demostracion",
    //   "picture_id": "https://codigofacilito.com/system/courses/thumbnails/000/000/188/original/Frame_22_%281%29.png?1639153561",
    //   "owner_id": "d72aa1f5-d20e-48a2-9e52-935da05ebd1b",
    // };
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28.0),
                topRight: Radius.circular(28.0),
              ),
              image: DecorationImage(
                image: NetworkImage(course.picture != 'notFound' && course.picture.isNotEmpty ? course.picture : "https://www.explore.com/img/gallery/the-50-most-incredible-landscapes-in-the-whole-entire-world/intro-1672072042.jpg" ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(course.creator != null && (course.creator!.picture != 'notFound' && course.creator!.picture.isNotEmpty) ? course.creator!.picture : 'https://cdn.iconscout.com/icon/free/png-256/avatar-380-456332.png'),
                  ),
                  const SizedBox(width: 20.0),
                  Text(
                    course.creator != null ? '${course.creator!.nickname.substring(0, min(course.creator!.nickname.length, 27))} ${course.creator!.nickname.length > 27 ? '...' : ''}' : 'Sin Creador',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    '${course.description.substring(0, min(course.description.length, 35))} ${course.description.length > 35 ? '...' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
