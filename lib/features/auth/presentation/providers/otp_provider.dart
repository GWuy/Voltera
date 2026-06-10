import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/register_request.dart';
import '../../data/services/otp_api_service.dart';
import '../../domain/repositories/auth_repository.dart';

/// OTP verification state managed by [OtpProvider].
enum OtpStatus { idle, verifying, success, error }

/// Manages OTP verification state, countdown timer, and registration completion.
///
/// Handles the full flow: verify OTP → register account → navigate to login.
class OtpProvider extends ChangeNotifier {
  OtpProvider({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  static const int resendCooldown = 60;

  // ── State ─────────────────────────────────────────────────────────────────
  OtpStatus _status = OtpStatus.idle;
  String? _errorMessage;
  int _countdown = resendCooldown;
  Timer? _timer;

  OtpStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get countdown => _countdown;
  bool get canResend => _countdown == 0;

  // ── Countdown ─────────────────────────────────────────────────────────────

  void startCountdown() {
    _countdown = resendCooldown;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
      } else {
        t.cancel();
      }
    });
    notifyListeners();
  }

  // ── Resend OTP ────────────────────────────────────────────────────────────

  Future<void> resendOtp(String email) async {
    if (!canResend) return;
    try {
      await _repository.resendOtp(email);
      _errorMessage = null;
      startCountdown();
    } on OtpException catch (e) {
      _errorMessage = e.userMessage;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ── Verify + Register ─────────────────────────────────────────────────────

  /// Verifies [otp] for [email], then creates the account using [registrationData].
  Future<void> verifyAndRegister({
    required String email,
    required String otp,
    required Map<String, dynamic> registrationData,
  }) async {
    _status = OtpStatus.verifying;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Verify OTP
      await _repository.verifyRegisterOtp(email, otp);

      // Step 2: Register account
      await _repository.register(
        RegisterRequest(
          username: registrationData['username'] as String,
          password: registrationData['password'] as String,
          role: registrationData['role'] as String?,
        ),
      );

      _status = OtpStatus.success;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = OtpStatus.error;
      _errorMessage = 'The code you entered is incorrect or expired.';
      notifyListeners();
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
