import 'package:connectionno_mobile/core/network/api_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth firebaseAuth;

  NoteRemoteDataSourceImpl({required this.apiManager, required this.firebaseAuth});

  Future<Map<String, String>> _getAuthHeaders() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final token = await user.getIdToken(); // Firebase'den token al
      return {'Authorization': 'Bearer $token'}; // Backend'e "Ben buyum" de
    }
    return {};
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    final headers = await _getAuthHeaders();
    final response = await apiManager.get(ApiConstants.notesEndpoint, headers: headers);

    final List data = response;
    return data.map((json) => NoteModel.fromJson(json)).toList();
  }

  @override
  Future<void> createNote(String title, String content) async {
    // POST isteği at
    final headers = await _getAuthHeaders();
    await apiManager.post(
      ApiConstants.notesEndpoint,
      data: {"title": title, "content": content},
      headers: headers,
    );
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final headers = await _getAuthHeaders();
    await apiManager.put(
      '${ApiConstants.notesEndpoint}/${note.id}',
      data: note.toJson(),
      headers: headers,
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final headers = await _getAuthHeaders();
    await apiManager.delete('${ApiConstants.notesEndpoint}/$id', headers: headers);
  }
}
