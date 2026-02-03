import 'package:connectionno_mobile/data/models/note_model.dart';
import 'package:connectionno_mobile/data/repositories/note_repository.dart';
import 'package:connectionno_mobile/data/repositories/note_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/api_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final notesBox = await Hive.openBox<NoteModel>('notes');
  sl.registerLazySingleton(() => notesBox);

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    ),
  );

  sl.registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl(dio: sl(), noteBox: sl()));
}
