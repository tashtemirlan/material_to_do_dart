import 'dart:convert';

DateTasksDataClass dateTasksDataClassFromJson(String str) => DateTasksDataClass.fromJson(json.decode(str));

String dateTasksDataClassToJson(DateTasksDataClass data) => json.encode(data.toJson());

class DateTasksDataClass {
  List<TaskDate>? tasks;

  DateTasksDataClass({
    this.tasks,
  });

  factory DateTasksDataClass.fromJson(Map<String, dynamic> json) => DateTasksDataClass(
    tasks: json["tasks"] == null ? [] : List<TaskDate>.from(json["tasks"]!.map((x) => TaskDate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
  };
}

class TaskDate {
  String? description;
  DateTime? finishDate;
  int? id;
  DateTime? startDate;
  String? status;
  int? taskGroupId;
  String? taskGroupName;
  String? title;

  TaskDate({
    this.description,
    this.finishDate,
    this.id,
    this.startDate,
    this.status,
    this.taskGroupId,
    this.taskGroupName,
    this.title,
  });

  factory TaskDate.fromJson(Map<String, dynamic> json) => TaskDate(
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