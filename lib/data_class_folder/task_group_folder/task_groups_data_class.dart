import 'dart:convert';

List<TaskGroupsDataClass> taskGroupsDataClassFromJson(String str) => List<TaskGroupsDataClass>.from(json.decode(str).map((x) => TaskGroupsDataClass.fromJson(x)));

String taskGroupsDataClassToJson(List<TaskGroupsDataClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskGroupsDataClass {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? name;
  int? iconData;
  String? backgroundColor;
  String? iconColor;
  int? userId;

  TaskGroupsDataClass({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.iconData,
    this.backgroundColor,
    this.iconColor,
    this.userId,
  });

  factory TaskGroupsDataClass.fromJson(Map<String, dynamic> json) => TaskGroupsDataClass(
    id: json["ID"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"] == null ? null : DateTime.parse(json["DeletedAt"]),
    name: json["name"],
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
    "icon_data": iconData,
    "background_color": backgroundColor,
    "icon_color": iconColor,
    "user_id": userId,
  };
}