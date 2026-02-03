// lib/core/services/injection_container.dart

import 'package:connectionno_mobile/data/models/note_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/api_constants.dart';

final sl = GetIt.instance; // sl: Service Locator

Future<void> init() async {
  // ---------------------------------------------------------------------------
  // 1. External (Harici Kütüphaneler)
  // ---------------------------------------------------------------------------

  // Hive Box (Veritabanı Kutusu)
  // Not: Hive.initFlutter() main.dart içinde çağrılmış olmalı.
  final notesBox = await Hive.openBox<NoteModel>('notes');
  sl.registerLazySingleton(() => notesBox);

  // Dio (HTTP İstemcisi)
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

  // ---------------------------------------------------------------------------
  // İlerleyen adımlarda buraya Repository ve Bloc'ları ekleyeceğiz.
  // ---------------------------------------------------------------------------
}
