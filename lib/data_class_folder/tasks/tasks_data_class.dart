import 'dart:convert';

List<TasksDataClass> tasksDataClassFromJson(String str) => List<TasksDataClass>.from(json.decode(str).map((x) => TasksDataClass.fromJson(x)));

String tasksDataClassToJson(List<TasksDataClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TasksDataClass {
  int? id;
  String? title;
  String? description;
  int? taskGroupId;
  DateTime? startDate;
  DateTime? finishDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  TasksDataClass({
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

  factory TasksDataClass.fromJson(Map<String, dynamic> json) => TasksDataClass(
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
