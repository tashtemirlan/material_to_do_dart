import 'dart:convert';

ForgetPasswordGenerateCodeDataClass forgetPasswordGenerateCodeDataClassFromJson(String str) => ForgetPasswordGenerateCodeDataClass.fromJson(json.decode(str));

String forgetPasswordGenerateCodeDataClassToJson(ForgetPasswordGenerateCodeDataClass data) => json.encode(data.toJson());

class ForgetPasswordGenerateCodeDataClass {
  String? code;

  ForgetPasswordGenerateCodeDataClass({
    this.code,
  });

  factory ForgetPasswordGenerateCodeDataClass.fromJson(Map<String, dynamic> json) => ForgetPasswordGenerateCodeDataClass(
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
  };
}