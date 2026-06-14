import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/token_storage.dart';
import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';
import '../../data/services/otp_api_service.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication state managed by [AuthProvider].
enum AuthStatus { idle, loading, success, error }

/// Manages login and registration state for the auth feature.
///
/// Widgets listen to this [ChangeNotifier] instead of directly calling
/// API services. All business logic lives here — screens are pure UI.
class AuthProvider extends ChangeNotifier {
  AuthProvider({required this._repository});

  final AuthRepository _repository;

  // ── State ─────────────────────────────────────────────────────────────────
  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  // ── Login ─────────────────────────────────────────────────────────────────

  /// Authenticates with [email] and [password].
  ///
  /// On success, saves the token and sets [loginResponse].
  /// On failure, sets [errorMessage].
  Future<void> login(String email, String password) async {
    _setLoading();

    try {
      final response = await _repository.login(
        LoginRequest(username: email.trim(), password: password),
      );

      await TokenStorage.instance.saveToken(response.token);

      _loginResponse = response;
      _status = AuthStatus.success;
      _errorMessage = null;
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.userMessage);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Register (Step 1: Request OTP) ────────────────────────────────────────

  /// Sends an OTP to [email] as the first step of registration.
  Future<void> requestRegistrationOtp(String email) async {
    _setLoading();

    try {
      await _repository.requestOtp(email.trim());
      _status = AuthStatus.success;
      _errorMessage = null;
      notifyListeners();
    } on OtpException catch (e) {
      _setError(e.userMessage);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void reset() {
    _status = AuthStatus.idle;
    _errorMessage = null;
    _loginResponse = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
