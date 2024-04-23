import 'package:leare_fa/models/course_model.dart';

class CreateCourseModel {
  String course_id;
  String course_name;
  String course_description;
  String picture_id;
  String? chat_id;
  List<String> categories;
  bool is_public;

  CreateCourseModel({
    this.course_id = '',
    required this.course_name,
    required this.course_description,
    required this.picture_id,
    this.chat_id,
    required this.categories,
    this.is_public = false,
  });

  static CreateCourseModel fromMap({required Map map}) {
    CreateCourseModel courseModel = CreateCourseModel(
      course_name: map['course_name'],
      course_description: map['course_description'],
      picture_id: map['picture_id'],
      chat_id: map['chat_id'],
      categories: (map['categories'] as List).map((e) => e.toString()).toList(),
    );
    return courseModel;
  }
}
