import 'package:dio/dio.dart';

/// Typed API exception that replaces raw [DioException] handling.
///
/// Provides a human-readable [userMessage] extracted from various
/// backend error response formats.
class ApiException implements Exception {
  const ApiException({
    required this.userMessage,
    this.statusCode,
    this.rawData,
  });

  final String userMessage;
  final int? statusCode;
  final dynamic rawData;

  /// Factory that converts a [DioException] into an [ApiException]
  /// with a user-friendly message extracted from the response body.
  ///
  /// Supports multiple backend error formats:
  /// - `{ "message": "..." }`
  /// - `{ "detail": "..." }`
  /// - `{ "error": "..." }`
  /// - `{ "errors": [{ "description": "..." }] }`
  /// - Plain string body
  factory ApiException.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final message = _extractMessage(data, e.message);

    // Map common HTTP status codes to user-friendly messages
    if (statusCode == 401) {
      return ApiException(
        userMessage: message.isNotEmpty
            ? message
            : 'Incorrect email or password.',
        statusCode: statusCode,
        rawData: data,
      );
    }
    if (statusCode == 409) {
      return ApiException(
        userMessage: message.isNotEmpty
            ? message
            : 'This resource already exists.',
        statusCode: statusCode,
        rawData: data,
      );
    }

    return ApiException(
      userMessage:
          message.isNotEmpty ? message : 'An unknown error occurred',
      statusCode: statusCode,
      rawData: data,
    );
  }

  static String _extractMessage(dynamic data, String? fallback) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      // Try common message fields
      final msg = map['message']?.toString() ??
          map['detail']?.toString() ??
          map['error']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;

      // Try nested errors array
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
    return fallback ?? '';
  }

  @override
  String toString() => 'ApiException($statusCode): $userMessage';
}
