import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiManager {
  final Dio _dio;

  ApiManager()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {"Content-Type": "application/json", "Accept": "application/json"},
        ),
      );

  // --- GET ---
  Future<dynamic> get(String path, {Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(path, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // --- POST ---
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // --- PUT ---
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // --- DELETE ---
  Future<dynamic> delete(String path, {Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(path, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
