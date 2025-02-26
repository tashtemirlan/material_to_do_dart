import 'dart:convert';

List<NotesDataClass> notesDataClassFromJson(String str) => List<NotesDataClass>.from(json.decode(str).map((x) => NotesDataClass.fromJson(x)));

String notesDataClassToJson(List<NotesDataClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotesDataClass {
  int? notesDataClassId;
  int? userId;
  String? title;
  String? description;
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  NotesDataClass({
    this.notesDataClassId,
    this.userId,
    this.title,
    this.description,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory NotesDataClass.fromJson(Map<String, dynamic> json) => NotesDataClass(
    notesDataClassId: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    id: json["ID"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"] == null ? null : DateTime.parse(json["DeletedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": notesDataClassId,
    "user_id": userId,
    "title": title,
    "description": description,
    "ID": id,
    "CreatedAt": createdAt?.toIso8601String(),
    "UpdatedAt": updatedAt?.toIso8601String(),
    "DeletedAt": deletedAt?.toIso8601String(),
  };
}