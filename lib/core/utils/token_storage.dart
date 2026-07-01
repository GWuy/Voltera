import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralised token storage backed by flutter_secure_storage.
/// Use [TokenStorage.instance] anywhere in the app.
class TokenStorage {
  TokenStorage._();
  static final instance = TokenStorage._();

  static const _kToken = 'auth_token';
  static const _kUserId = 'auth_user_id';
  static const _kRole = 'auth_role';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) =>
      _storage.write(key: _kToken, value: token);

  Future<void> saveSession({
    required String token,
    required int userId,
    required String role,
  }) async {
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kUserId, value: userId.toString());
    await _storage.write(key: _kRole, value: role);
  }

  Future<String?> getToken() => _storage.read(key: _kToken);

  Future<String?> getUserId() => _storage.read(key: _kUserId);

  Future<void> saveUserId(String userId) =>
      _storage.write(key: _kUserId, value: userId);

  Future<String?> getRole() => _storage.read(key: _kRole);

  Future<void> deleteToken() => _storage.delete(key: _kToken);

  Future<void> clearSession() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kUserId);
    await _storage.delete(key: _kRole);
  }
}
