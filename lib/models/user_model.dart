class UserModel {
  String id;
  String name;
  String lastname;
  String nickname;
  String email;
  String nationality;
  String? picture_id;
  String? web_site;
  String? biography;
  String? linkedin_link;
  String? facebook_link;
  String? twitter_link;
  String? created_at;
  String? updated_at;

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
    this.created_at,
    this.updated_at,
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
        
        if (map['created_at'] != null) {
          userModel.created_at = map['created_at'];
        }
        else {
          userModel.created_at = "n/a";
        }

        if (map['updated_at'] != null) {
          userModel.updated_at = map['updated_at'];
        }
        else {
          userModel.updated_at = "n/a";
        }

        return userModel;
  }
}