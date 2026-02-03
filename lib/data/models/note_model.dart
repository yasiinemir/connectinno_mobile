import 'package:hive/hive.dart';

// 👇 BU SATIR EKSİK OLDUĞU İÇİN ÇALIŞMIYORDU 👇
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  bool isPinned;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isSynced;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    required this.createdAt,
    this.isSynced = true,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isPinned: json['is_pinned'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isSynced: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "content": content, "is_pinned": isPinned};
  }
}
