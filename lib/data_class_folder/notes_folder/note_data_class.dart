import 'dart:convert';

NoteDataClass noteDataClassFromJson(String str) => NoteDataClass.fromJson(json.decode(str));

String noteDataClassToJson(NoteDataClass data) => json.encode(data.toJson());

class NoteDataClass {
  int? noteDataClassId;
  int? userId;
  String? title;
  String? description;
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  NoteDataClass({
    this.noteDataClassId,
    this.userId,
    this.title,
    this.description,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory NoteDataClass.fromJson(Map<String, dynamic> json) => NoteDataClass(
    noteDataClassId: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    id: json["ID"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    deletedAt: json["DeletedAt"] == null ? null : DateTime.parse(json["DeletedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": noteDataClassId,
    "user_id": userId,
    "title": title,
    "description": description,
    "ID": id,
    "CreatedAt": createdAt?.toIso8601String(),
    "UpdatedAt": updatedAt?.toIso8601String(),
    "DeletedAt": deletedAt?.toIso8601String(),
  };
}
