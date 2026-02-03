import 'package:uuid/uuid.dart'; // pubspec'e ekli olmalı
import '../../core/network/network_info.dart';
import '../../data/datasources/note_local_data_source.dart';
import '../../data/datasources/note_remote_data_source.dart';
import '../../data/models/note_model.dart';
import '../../data/models/sync_task_model.dart';
import 'note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;
  final NoteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final _uuid = const Uuid();

  NoteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<NoteModel>> getNotes() async {
    if (await networkInfo.isConnected) {
      try {
        await syncPendingChanges();

        final remoteNotes = await remoteDataSource.getNotes();

        await localDataSource.cacheNotes(remoteNotes);
        return remoteNotes;
      } catch (e) {
        return await localDataSource.getNotes();
      }
    } else {
      return await localDataSource.getNotes();
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
    await localDataSource.addNote(newNote);

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createNote(title, content);

        final notes = await remoteDataSource.getNotes();
        await localDataSource.cacheNotes(notes);
      } catch (e) {
        await _queueTask(SyncAction.create, {"title": title, "content": content});
      }
    } else {
      await _queueTask(SyncAction.create, {"title": title, "content": content});
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    note.isSynced = false;
    await localDataSource.updateNote(note);

    final payload = note.toJson();
    payload['id'] = note.id;

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateNote(note);
        note.isSynced = true;
        await localDataSource.updateNote(note);
      } catch (e) {
        await _queueTask(SyncAction.update, payload);
      }
    } else {
      await _queueTask(SyncAction.update, payload);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteNote(id);
      } catch (e) {
        await _queueTask(SyncAction.delete, {"id": id});
      }
    } else {
      await _queueTask(SyncAction.delete, {"id": id});
    }
  }

  Future<void> _queueTask(SyncAction action, Map<String, dynamic> data) async {
    final task = SyncTaskModel(
      id: _uuid.v4(),
      action: action,
      payload: data,
      createdAt: DateTime.now(),
    );
    await localDataSource.addToQueue(task);
  }

  @override
  Future<void> syncPendingChanges() async {
    final queue = await localDataSource.getQueue();
    if (queue.isEmpty) return;

    queue.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (var task in queue) {
      try {
        switch (task.action) {
          case SyncAction.create:
            await remoteDataSource.createNote(task.payload['title'], task.payload['content']);
            break;
          case SyncAction.update:
            final note = NoteModel.fromJson(task.payload);
            await remoteDataSource.updateNote(note);
            break;
          case SyncAction.delete:
            await remoteDataSource.deleteNote(task.payload['id']);
            break;
        }

        await localDataSource.deleteFromQueue(task.key);
      } catch (e) {
        print("Sync Hatası: $e");
      }
    }
  }
}
