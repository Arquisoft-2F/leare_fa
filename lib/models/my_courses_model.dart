class MyCoursesModel {
  final List<Course> courses;

  MyCoursesModel({
    required this.courses,
  });

  static MyCoursesModel fromMap({required Map map}) => MyCoursesModel(
    courses: (map['courses'] as List).map((e) => Course.fromMap(map: e)).toList(),
  );
}

class Course {
  final String id;
  final String name;
  final String description;
  final String picture;
  final Creator? creator;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.creator,
  });

  static Course fromMap({required Map map}) => Course(
    id: map['course_id'],
    name: map['course_name'],
    description: map['course_description'],
    picture: map['picture_id'],
    creator: map['creator'] != null ? Creator.fromMap(map: map['creator']) : null,
  );
}

class Creator {
  final String id;
  final String nickname;
  final String picture;

  Creator({
    required this.id,
    required this.nickname,
    required this.picture,
  });

  static Creator fromMap({required Map map}) => Creator(
    id: map['id'],
    nickname: map['nickname'],
    picture: map['picture_id'],
  );
}