class SearchModel {
  final PostHighlight highlight;
  final PostRecomendation post;

  SearchModel({required this.highlight, required this.post});

  static SearchModel fromMap({required Map map}) => SearchModel(
    highlight: PostHighlight.fromMap(map: map['highlight']),
    post: PostRecomendation.fromMap(map: map['post']),
  );
}

class PostRecomendation {
  final String id;
  final String name;
  final String type;
  final String? lastname;
  final String? nickname;
  final String? description;
  final String? picture;

  PostRecomendation({
    required this.id,
    required this.name,
    required this.type,
    this.lastname,
    this.nickname,
    this.description,
    this.picture,
  });

  static PostRecomendation fromMap({required Map map}) => PostRecomendation(
    id: map['id'],
    name: map['name'],
    type: map['type'],
    lastname: map['lastname'],
    nickname: map['nickname'],
    description: map['description'],
    picture: map['picture'],
  );

}

class PostHighlight {
  final List<dynamic>? name;
  final List<dynamic>? lastname;
  final List<dynamic>? nickname;
  final List<dynamic>? description;

  PostHighlight({
    this.name,
    this.lastname,
    this.nickname,
    this.description,
  });

  static PostHighlight fromMap({required Map map}) => PostHighlight(
    name: map['name'],
    lastname: map['lastname'],
    nickname: map['nickname'],
    description: map['description'],
  );

}
