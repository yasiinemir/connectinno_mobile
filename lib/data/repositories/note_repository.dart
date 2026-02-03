import '../models/note_model.dart';

abstract class NoteRepository {
  Future<List<NoteModel>> getNotes();
  Future<void> createNote(String title, String content);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);

  Future<void> syncPendingChanges();
}
