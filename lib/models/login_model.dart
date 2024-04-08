class LoginModel {
  final String flag;
  final String message;
  final String? token;

  LoginModel({required this.flag, required this.message, this.token});

  static LoginModel fromMap({required Map map}) => LoginModel(
      flag: map['flag'], message: map['message'], token: map['token']);
}
