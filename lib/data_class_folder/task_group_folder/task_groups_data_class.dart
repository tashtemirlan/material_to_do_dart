// To parse this JSON data, do
//
//     final taskGroupsDataClass = taskGroupsDataClassFromJson(jsonString);

import 'dart:convert';

List<TaskGroupsDataClass> taskGroupsDataClassFromJson(String str) => List<TaskGroupsDataClass>.from(json.decode(str).map((x) => TaskGroupsDataClass.fromJson(x)));

String taskGroupsDataClassToJson(List<TaskGroupsDataClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskGroupsDataClass {
  int? id;
  String? name;
  String? description;
  int? iconData;
  String? backgroundColor;
  String? iconColor;
  int? userId;
  int? totalTasks;
  int? completionRate;

  TaskGroupsDataClass({
    this.id,
    this.name,
    this.description,
    this.iconData,
    this.backgroundColor,
    this.iconColor,
    this.userId,
    this.totalTasks,
    this.completionRate,
  });

  factory TaskGroupsDataClass.fromJson(Map<String, dynamic> json) => TaskGroupsDataClass(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    iconData: json["icon_data"],
    backgroundColor: json["background_color"],
    iconColor: json["icon_color"],
    userId: json["user_id"],
    totalTasks: json["total_tasks"],
    completionRate: json["completion_rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "icon_data": iconData,
    "background_color": backgroundColor,
    "icon_color": iconColor,
    "user_id": userId,
    "total_tasks": totalTasks,
    "completion_rate": completionRate,
  };
}
