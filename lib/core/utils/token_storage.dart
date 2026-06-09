import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralised token storage backed by flutter_secure_storage.
/// Use [TokenStorage.instance] anywhere in the app.
class TokenStorage {
  TokenStorage._();
  static final instance = TokenStorage._();

  static const _kToken = 'auth_token';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) =>
      _storage.write(key: _kToken, value: token);

  Future<String?> getToken() => _storage.read(key: _kToken);

  Future<void> deleteToken() => _storage.delete(key: _kToken);
}
