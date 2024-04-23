import 'package:leare_fa/models/feed_model.dart';

class EnrollModel {
  double progress;
  double score;
  DateTime listed_on;
  Course course;

  EnrollModel({
    required this.progress,
    required this.score,
    required this.listed_on,
    required this.course,
  });

  static EnrollModel fromMap({required Map map}) {
    Course course = Course.fromMap(map: map['course']);
    EnrollModel categoryModel = EnrollModel(
        progress: map['progress'],
        score: map['score'],
        listed_on: DateTime.parse(map['listed_on']),
        course: course);
    return categoryModel;
  }
}
