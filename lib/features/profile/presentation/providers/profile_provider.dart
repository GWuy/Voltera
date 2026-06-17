import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/profile_request.dart';
import '../../data/models/profile_response.dart';
import '../../domain/repositories/profile_repository.dart';

/// Profile state managed by [ProfileProvider].
enum ProfileStatus { idle, loading, success, error }

/// Manages profile load/save state for the fill-profile screen.
class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required ProfileRepository repository})
      : _repository = repository;

  final ProfileRepository _repository;

  // ── State ─────────────────────────────────────────────────────────────────
  ProfileStatus _status = ProfileStatus.idle;
  String? _errorMessage;
  ProfileResponse? _profile;

  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  ProfileResponse? get profile => _profile;

  // ── Load profile ──────────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    _status = ProfileStatus.loading;
    notifyListeners();

    try {
      _profile = await _repository.getMyProfile();
      _status = ProfileStatus.success;
      _errorMessage = null;
    } catch (_) {
      // Profile load is non-critical — allow manual entry
      _status = ProfileStatus.idle;
    }
    notifyListeners();
  }

  // ── Save profile ──────────────────────────────────────────────────────────

  Future<bool> saveProfile(ProfileRequest request) async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveProfile(request);
      _status = ProfileStatus.success;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = e.userMessage;
      notifyListeners();
      return false;
    } catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<String?> uploadAvatar(File imageFile) async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = await _repository.uploadAvatar(imageFile);
      _status = ProfileStatus.success;
      notifyListeners();
      return url;
    } on ApiException catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = e.userMessage;
      notifyListeners();
      return null;
    } catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> logout(String username) async {
    _status = ProfileStatus.loading;
    notifyListeners();
    try {
      await _repository.logout(username);
      _status = ProfileStatus.idle;
      _profile = null;
      notifyListeners();
      return true;
    } catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
