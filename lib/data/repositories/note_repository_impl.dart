import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';
import 'note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final Dio dio;
  final Box<NoteModel> noteBox;
  final _uuid = const Uuid();

  NoteRepositoryImpl({required this.dio, required this.noteBox});

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final response = await dio.get('/notes');

      if (response.statusCode == 200) {
        final List data = response.data;

        final remoteNotes = data.map((e) => NoteModel.fromJson(e)).toList();

        await noteBox.clear();
        await noteBox.addAll(remoteNotes);

        return remoteNotes;
      } else {
        return noteBox.values.toList();
      }
    } catch (e) {
      print("Offline Mod: API'ye ulaşılamadı. Local veri dönülüyor. Hata: $e");
      return noteBox.values.toList();
    }
  }

  @override
  Future<void> createNote(String title, String content) async {
    final tempId = _uuid.v4();

    final newNote = NoteModel(
      id: tempId,
      title: title,
      content: content,
      createdAt: DateTime.now(),
      isSynced: false,
    );

    await noteBox.put(tempId, newNote);

    try {
      final response = await dio.post('/notes', data: newNote.toJson());

      if (response.statusCode == 200) {
        final serverNote = NoteModel.fromJson(response.data);

        await noteBox.delete(tempId);
        await noteBox.put(serverNote.id, serverNote);
      }
    } catch (e) {
      print("Offline Mod: Not sadece locale kaydedildi.");
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    note.isSynced = false;
    await note.save();

    try {
      final response = await dio.put('/notes/${note.id}', data: note.toJson());

      if (response.statusCode == 200) {
        note.isSynced = true;
        await note.save();
      }
    } catch (e) {
      print("Offline Mod: Güncelleme kuyrukta bekliyor.");
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final noteToDelete = noteBox.values.firstWhere((element) => element.id == id);
    await noteToDelete.delete();

    try {
      await dio.delete('/notes/$id');
    } catch (e) {
      print("Offline Mod: Silme işlemi sunucuya iletilemedi.");
    }
  }
}
