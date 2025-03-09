import 'dart:convert';

List<TodoTasksDataClass> todoTasksDataClassFromJson(String str) => List<TodoTasksDataClass>.from(json.decode(str).map((x) => TodoTasksDataClass.fromJson(x)));

String todoTasksDataClassToJson(List<TodoTasksDataClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoTasksDataClass {
  String? description;
  DateTime? finishDate;
  int? id;
  DateTime? startDate;
  String? status;
  int? taskGroupId;
  String? taskGroupName;
  String? title;

  TodoTasksDataClass({
    this.description,
    this.finishDate,
    this.id,
    this.startDate,
    this.status,
    this.taskGroupId,
    this.taskGroupName,
    this.title,
  });

  factory TodoTasksDataClass.fromJson(Map<String, dynamic> json) => TodoTasksDataClass(
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