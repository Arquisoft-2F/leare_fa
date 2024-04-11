class UserModel {
  final String id;
  final String name;
  final String lastname;
  final String nickname;
  final String email;
  final String nationality;
  String? picture_id;
  String? web_site;
  String? biography;
  String? linkedin_link;
  String? facebook_link;
  String? twitter_link;

  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.nickname,
    required this.email,
    required this.nationality,
    this.picture_id,
    this.web_site,
    this.biography,
    this.linkedin_link,
    this.facebook_link,
    this.twitter_link,
  });

  static UserModel fromMap({required Map map}) { 
    UserModel userModel = UserModel(
        id: map['id'],
        name: map['name'],
        lastname: map['lastname'],
        nickname: map['nickname'],
        email: map['email'],
        nationality: map['nationality'],
        );
        
        if (map['picture_id'] != null) {
          userModel.picture_id = map['picture_id'];
        }
        else {
          userModel.picture_id = "n/a";
        }

        if (map['web_site'] != null) {
          userModel.web_site = map['web_site'];
        }
        else {
          userModel.web_site = "n/a";
        }

        if (map['biography'] != null) {
          userModel.biography = map['biography'];
        }
        else {
          userModel.biography = "n/a";
        }

        if (map['linkedin_link'] != null) {
          userModel.linkedin_link = map['linkedin_link'];
        }
        else {
          userModel.linkedin_link = "n/a";
        }

        if (map['facebook_link'] != null) {
          userModel.facebook_link = map['facebook_link'];
        }
        else {
          userModel.facebook_link = "n/a";
        }
        
        if (map['twitter_link'] != null) {
          userModel.twitter_link = map['twitter_link'];
        }
        else {
          userModel.twitter_link = "n/a";
        }
        
        return userModel;
  }
}
