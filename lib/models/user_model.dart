class UserModel {
  final String? id;
  final String? name;
  final String? lastname;
  final String? nickname;
  final String? email;
  final String? nationality;
  final String? picture_id;
  final String? web_site;
  final String? biography;
  final String? linkedin_link;
  final String? facebook_link;
  final String? twitter_link;

  UserModel({
    this.id,
    this.name,
    this.lastname,
    this.nickname,
    this.email,
    this.nationality,
    this.picture_id,
    this.web_site,
    this.biography,
    this.linkedin_link,
    this.facebook_link,
    this.twitter_link,
  });

  static UserModel fromMap({required Map map}) => UserModel(
        id: map['id'],
        name: map['name'],
        lastname: map['lastname'],
        nickname: map['nickname'],
        email: map['email'],
        nationality: map['nationality'],
        picture_id: map['picture_id'],
        web_site: map['web_site'],
        biography: map['biography'],
        linkedin_link: map['linkedin_link'],
        facebook_link: map['facebook_link'],
        twitter_link: map['twitter_link'],
        );
}
