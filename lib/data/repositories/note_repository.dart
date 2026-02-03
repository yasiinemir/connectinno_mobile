import '../models/note_model.dart';

abstract class NoteRepository {
  // Notları getir
  Future<List<NoteModel>> getNotes();

  // Not oluştur
  Future<void> createNote(String title, String content);

  // Not güncelle
  Future<void> updateNote(NoteModel note);

  // Not sil
  Future<void> deleteNote(String id);
}
