import 'dart:convert';

TaskDataClass taskDataClassFromJson(String str) => TaskDataClass.fromJson(json.decode(str));

String taskDataClassToJson(TaskDataClass data) => json.encode(data.toJson());

class TaskDataClass {
  String? description;
  DateTime? finishDate;
  int? id;
  DateTime? startDate;
  String? status;
  int? taskGroupId;
  String? taskGroupName;
  String? title;

  TaskDataClass({
    this.description,
    this.finishDate,
    this.id,
    this.startDate,
    this.status,
    this.taskGroupId,
    this.taskGroupName,
    this.title,
  });

  factory TaskDataClass.fromJson(Map<String, dynamic> json) => TaskDataClass(
    description: json["description"],
    finishDate: json["finish_date"] == null ? null : DateTime.parse(json["finish_date"]),
    id: json["id"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    status: json["status"],
    taskGroupId: json["task_group_id"],
    taskGroupName: json["task_group_name"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "finish_date": finishDate?.toIso8601String(),
    "id": id,
    "start_date": startDate?.toIso8601String(),
    "status": status,
    "task_group_id": taskGroupId,
    "task_group_name": taskGroupName,
    "title": title,
  };
}