import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiManager {
  final Dio _dio;

  // Constructor çalıştığında Dio'yu temel ayarlarla hazırlar
  ApiManager()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl, // Base URL buradan gelir
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {"Content-Type": "application/json", "Accept": "application/json"},
        ),
      );

  // --- GET ---
  Future<dynamic> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } catch (e) {
      rethrow; // Hatayı olduğu gibi fırlat, Repository yakalasın
    }
  }

  // --- POST ---
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // --- PUT ---
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // --- DELETE ---
  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
