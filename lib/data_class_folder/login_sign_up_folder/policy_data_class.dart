import 'dart:convert';

PolicyDataClass policyDataClassFromJson(String str) => PolicyDataClass.fromJson(json.decode(str));

String policyDataClassToJson(PolicyDataClass data) => json.encode(data.toJson());

class PolicyDataClass {
  String? data;

  PolicyDataClass({
    this.data,
  });

  factory PolicyDataClass.fromJson(Map<String, dynamic> json) => PolicyDataClass(
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}