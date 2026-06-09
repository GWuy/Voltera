import 'package:dio/dio.dart';

import '../../../core/config/api_config.dart';

class OtpService {
  OtpService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.rootApi,
                headers: {'Content-Type': 'application/json'},
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  // ── Request OTP (POST /otp/request?email=..., body = null) ─────────────────
  Future<void> requestOtp(String email) async {
    try {
      await _dio.post(
        '/otp/request',
        queryParameters: {'email': email},
        data: null,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // ── Verify OTP for registration ─────────────────────────────────────────────
  Future<void> verifyRegisterOtp(String email, String otp) async {
    try {
      await _dio.post(
        '/otp/verify/register',
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // ── Resend OTP (POST /otp/resend?email=..., body = null) ───────────────────
  Future<void> resendOtp(String email) async {
    try {
      await _dio.post(
        '/otp/resend',
        queryParameters: {'email': email},
        data: null,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // ── Error mapping ──────────────────────────────────────────────────────────
  OtpException _mapError(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;

    String message = _extractMessage(data, e.message);

    final lowerMsg = message.toLowerCase();

    if (statusCode == 409 ||
        lowerMsg.contains('exist') ||
        lowerMsg.contains('already')) {
      return OtpException(OtpErrorKind.emailAlreadyExists, message);
    }

    if (statusCode == 400 && lowerMsg.contains('validation')) {
      return OtpException(OtpErrorKind.validationError, message);
    }

    return OtpException(OtpErrorKind.unknown, message);
  }

  String _extractMessage(dynamic data, String? fallback) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final msg =
          map['message']?.toString() ??
          map['detail']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;

      final errors = map['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors[0];
        if (first is Map) {
          final desc = first['description']?.toString();
          if (desc != null && desc.trim().isNotEmpty) return desc;
        }
      }
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return fallback ?? 'An unknown error occurred';
  }
}

enum OtpErrorKind { emailAlreadyExists, validationError, unknown }

class OtpException implements Exception {
  const OtpException(this.kind, this.message);
  final OtpErrorKind kind;
  final String message;

  @override
  String toString() => message;

  String get userMessage {
    switch (kind) {
      case OtpErrorKind.emailAlreadyExists:
        return 'This email is already registered.';
      case OtpErrorKind.validationError:
        return 'Invalid data. Please check your input.';
      case OtpErrorKind.unknown:
        return message;
    }
  }
}
