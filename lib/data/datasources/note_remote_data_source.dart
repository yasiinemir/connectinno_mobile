import 'package:connectionno_mobile/core/network/api_manager.dart';

import '../../core/constants/api_constants.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> createNote(String title, String content);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final ApiManager apiManager;

  NoteRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<List<NoteModel>> getNotes() async {
    final response = await apiManager.get(ApiConstants.notesEndpoint);

    final List data = response;
    return data.map((json) => NoteModel.fromJson(json)).toList();
  }

  @override
  Future<void> createNote(String title, String content) async {
    // POST isteği at
    await apiManager.post(ApiConstants.notesEndpoint, data: {"title": title, "content": content});
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await apiManager.put('${ApiConstants.notesEndpoint}/${note.id}', data: note.toJson());
  }

  @override
  Future<void> deleteNote(String id) async {
    await apiManager.delete('${ApiConstants.notesEndpoint}/$id');
  }
}
