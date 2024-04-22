class FeedModel {
  final Category category;
  final List<Course> courses;

  FeedModel({
    required this.category,
    required this.courses,
  });

  static FeedModel fromMap({required Map map}) => FeedModel(
    category: Category.fromMap(map: map['category'] ?? {}),
    courses: (map['courses'] as List).map((e) => Course.fromMap(map: e)).toList(),
  );
}

class Course {
  final String id;
  final String name;
  final String description;
  final String picture;
  final String? creatorId;
  final Creator? creator;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.creatorId,
    required this.creator,
  });

  static Course fromMap({required Map map}) => Course(
    id: map['course_id'],
    name: map['course_name'],
    description: map['course_description'],
    picture: map['picture_id'],
    creatorId: map['creator_id'],
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
    picture: map['picture_id'] != null ? map['picture_id'] : '',
  );
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  static Category fromMap({required Map map}) => Category(
    id: map['category_id'],
    name: map['category_name'],
  );
}