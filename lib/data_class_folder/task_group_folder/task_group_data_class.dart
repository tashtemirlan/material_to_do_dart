// To parse this JSON data, do
//
//     final taskGroupDataClass = taskGroupDataClassFromJson(jsonString);

import 'dart:convert';

TaskGroupDataClass taskGroupDataClassFromJson(String str) => TaskGroupDataClass.fromJson(json.decode(str));

String taskGroupDataClassToJson(TaskGroupDataClass data) => json.encode(data.toJson());

class TaskGroupDataClass {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? name;
  String? description;
  int? iconData;
  String? backgroundColor;
  String? iconColor;
  int? userId;

  TaskGroupDataClass({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.description,
    this.iconData,
    this.backgroundColor,
    this.iconColor,
    this.userId,
  });

  factory TaskGroupDataClass.fromJson(Map<String, dynamic> json) => TaskGroupDataClass(
    id: json["ID"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"] == null ? null : DateTime.parse(json["DeletedAt"]),
    name: json["name"],
    description: json["description"],
    iconData: json["icon_data"],
    backgroundColor: json["background_color"],
    iconColor: json["icon_color"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "CreatedAt": createdAt?.toIso8601String(),
    "UpdatedAt": updatedAt?.toIso8601String(),
    "DeletedAt": deletedAt?.toIso8601String(),
    "name": name,
    "description": description,
    "icon_data": iconData,
    "background_color": backgroundColor,
    "icon_color": iconColor,
    "user_id": userId,
  };
}
