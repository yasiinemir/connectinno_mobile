import 'package:hive/hive.dart';
import '../models/note_model.dart';
import '../models/sync_task_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> cacheNotes(List<NoteModel> notes);
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);

  Future<void> addToQueue(SyncTaskModel task);
  Future<List<SyncTaskModel>> getQueue();
  Future<void> deleteFromQueue(dynamic key);
  Future<void> clearQueue();

  Future<void> clearAll();
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box<NoteModel> noteBox;
  final Box<SyncTaskModel> queueBox;

  NoteLocalDataSourceImpl({required this.noteBox, required this.queueBox});

  @override
  Future<List<NoteModel>> getNotes() async {
    return noteBox.values.toList();
  }

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    await noteBox.clear();
    await noteBox.addAll(notes);
  }

  @override
  Future<void> addNote(NoteModel note) async {
    await noteBox.put(note.id, note);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await noteBox.put(note.id, note);
  }

  @override
  Future<void> deleteNote(String id) async {
    final key = noteBox.keys.firstWhere((k) => noteBox.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await noteBox.delete(key);
    }
  }

  @override
  Future<void> addToQueue(SyncTaskModel task) async {
    await queueBox.add(task);
  }

  @override
  Future<List<SyncTaskModel>> getQueue() async {
    return queueBox.values.toList();
  }

  @override
  Future<void> deleteFromQueue(dynamic key) async {
    await queueBox.delete(key);
  }

  @override
  Future<void> clearQueue() async {
    await queueBox.clear();
  }

  @override
  Future<void> clearAll() async {
    await noteBox.clear();
    await queueBox.clear();
  }
}
