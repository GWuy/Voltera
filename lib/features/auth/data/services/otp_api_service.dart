import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:voltera/core/network/api_client.dart';
import 'package:voltera/core/network/api_exception.dart';

/// Low-level API service for OTP-related endpoints.
///
/// Uses a public (unauthenticated) [Dio] instance.
class OtpApiService {
  OtpApiService({Dio? dio}) : _dio = dio ?? ApiClient.createPublicDio();

  final Dio _dio;

  /// POST /otp/request?email=...
  Future<void> requestOtp(String email) async {
    try {
      await _dio.post(
        '/otp/request',
        queryParameters: {'email': email},
        data: null,
      );
    } on DioException catch (e) {
      debugPrint('OtpApiService.requestOtp: ${e.response?.statusCode}');
      throw _mapException(e);
    }
  }

  /// POST /otp/verify/register
  Future<void> verifyRegisterOtp(String email, String otp) async {
    try {
      await _dio.post(
        '/otp/verify/register',
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      debugPrint('OtpApiService.verifyOtp: ${e.response?.statusCode}');
      throw _mapException(e);
    }
  }

  /// POST /otp/resend?email=...
  Future<void> resendOtp(String email) async {
    try {
      await _dio.post(
        '/otp/resend',
        queryParameters: {'email': email},
        data: null,
      );
    } on DioException catch (e) {
      debugPrint('OtpApiService.resendOtp: ${e.response?.statusCode}');
      throw _mapException(e);
    }
  }

  /// Maps [DioException] to a more specific [OtpException] or generic [ApiException].
  Exception _mapException(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final apiEx = ApiException.fromDioException(e);
    final lowerMsg = apiEx.userMessage.toLowerCase();

    if (statusCode == 409 ||
        lowerMsg.contains('exist') ||
        lowerMsg.contains('already')) {
      return OtpException(OtpErrorKind.emailAlreadyExists, apiEx.userMessage);
    }

    if (statusCode == 400 && lowerMsg.contains('validation')) {
      return OtpException(OtpErrorKind.validationError, apiEx.userMessage);
    }

    return OtpException(OtpErrorKind.unknown, apiEx.userMessage);
  }
}

// ── OTP-specific error types ────────────────────────────────────────────────

enum OtpErrorKind { emailAlreadyExists, validationError, unknown }

class OtpException implements Exception {
  const OtpException(this.kind, this.message);
  final OtpErrorKind kind;
  final String message;

  @override
  String toString() => message;

  String get userMessage => switch (kind) {
    OtpErrorKind.emailAlreadyExists => 'This email is already registered.',
    OtpErrorKind.validationError => 'Invalid data. Please check your input.',
    OtpErrorKind.unknown => message,
  };
}
