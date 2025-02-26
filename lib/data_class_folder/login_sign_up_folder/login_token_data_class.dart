import 'dart:convert';

LoginTokenDataClass loginTokenDataClassFromJson(String str) => LoginTokenDataClass.fromJson(json.decode(str));

String loginTokenDataClassToJson(LoginTokenDataClass data) => json.encode(data.toJson());

class LoginTokenDataClass {
  String? token;

  LoginTokenDataClass({
    this.token,
  });

  factory LoginTokenDataClass.fromJson(Map<String, dynamic> json) => LoginTokenDataClass(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}