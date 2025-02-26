import 'dart:convert';

UserDataClass userDataClassFromJson(String str) => UserDataClass.fromJson(json.decode(str));

String userDataClassToJson(UserDataClass data) => json.encode(data.toJson());

class UserDataClass {
  String? email;
  String? fullName;
  int? id;
  String? image;

  UserDataClass({
    this.email,
    this.fullName,
    this.id,
    this.image,
  });

  factory UserDataClass.fromJson(Map<String, dynamic> json) => UserDataClass(
    email: json["email"],
    fullName: json["full_name"],
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "full_name": fullName,
    "id": id,
    "image": image,
  };
}