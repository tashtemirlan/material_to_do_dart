import 'dart:convert';

TaskDataClass taskDataClassFromJson(String str) => TaskDataClass.fromJson(json.decode(str));

String taskDataClassToJson(TaskDataClass data) => json.encode(data.toJson());

class TaskDataClass {
  int? id;
  String? title;
  String? description;
  int? taskGroupId;
  DateTime? startDate;
  DateTime? finishDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  TaskDataClass({
    this.id,
    this.title,
    this.description,
    this.taskGroupId,
    this.startDate,
    this.finishDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskDataClass.fromJson(Map<String, dynamic> json) => TaskDataClass(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    taskGroupId: json["task_group_id"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    finishDate: json["finish_date"] == null ? null : DateTime.parse(json["finish_date"]),
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "task_group_id": taskGroupId,
    "start_date": startDate?.toIso8601String(),
    "finish_date": finishDate?.toIso8601String(),
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}