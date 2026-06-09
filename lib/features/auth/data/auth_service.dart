import 'package:dio/dio.dart';

import '../../../core/config/api_config.dart';
import 'login_request.dart';
import 'login_response.dart';
import 'register_request.dart';
import 'register_response.dart';

class AuthService {
  AuthService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.authBaseUrl,
                headers: {'Content-Type': 'application/json'},
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  // ── Register ────────────────────────────────────────────────────────────────
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/register',
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('DATA:   ${e.response?.data}');
      rethrow;
    }
  }

  // ── Login ───────────────────────────────────────────────────────────────────
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('DATA:   ${e.response?.data}');
      rethrow;
    }
  }
}
