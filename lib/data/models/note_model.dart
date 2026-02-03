import 'package:hive/hive.dart';

part 'note_model.g.dart'; // Bu satır kızaracak, korkma. Build runner çalışınca düzelecek.

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  bool isSynced; // İnternet yokken false olacak, sunucuya gidince true olacak.

  @HiveField(5)
  bool isFavorite; // Favorilere alma

  @HiveField(6)
  bool isPinned; // Başa sabitleme

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isSynced = false,
    this.isFavorite = false,
    this.isPinned = false,
  });

  // API'den gelen JSON'ı modele çevirmek için
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isSynced: true, // Sunucudan geliyorsa zaten senkronizedir
      isFavorite: json['is_favorite'] ?? false,
      isPinned: json['is_pinned'] ?? false,
    );
  }

  // Modeli API'ye göndermek için JSON'a çevirmek
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "created_at": createdAt.toIso8601String(),
      "is_favorite": isFavorite,
      "is_pinned": isPinned,
    };
  }
}
