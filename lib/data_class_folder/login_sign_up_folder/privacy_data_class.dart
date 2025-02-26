import 'dart:convert';

PrivacyDataClass privacyDataClassFromJson(String str) => PrivacyDataClass.fromJson(json.decode(str));

String privacyDataClassToJson(PrivacyDataClass data) => json.encode(data.toJson());

class PrivacyDataClass {
  String? data;

  PrivacyDataClass({
    this.data,
  });

  factory PrivacyDataClass.fromJson(Map<String, dynamic> json) => PrivacyDataClass(
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}