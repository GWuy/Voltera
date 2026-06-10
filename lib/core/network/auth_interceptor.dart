import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../utils/token_storage.dart';

/// Dio [Interceptor] that automatically attaches `Authorization: Bearer <token>`
/// to every outgoing request when a token is available.
///
/// This removes the need for services to manually manage tokens via constructors.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.instance.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Log for debugging 403 issues
    debugPrint('--> HTTP ${options.method} ${options.baseUrl}${options.path}');
    debugPrint('Headers: ${options.headers}');
    if (options.data is FormData) {
      debugPrint('Body: Multipart/FormData');
    } else {
      debugPrint('Body: ${options.data}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Future: handle 401 → auto-logout / token refresh
    handler.next(err);
  }
}
