// lib/data/local/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorage {
  static const _access  = 'access_token';
  static const _refresh = 'refresh_token';
  static const _role    = 'user_role';
  static const _userId  = 'user_id';

  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  // ── Tokens ────────────────────────────────────────────────────
  Future<void>    saveAccessToken(String token)  => _storage.write(key: _access,  value: token);
  Future<void>    saveRefreshToken(String token) => _storage.write(key: _refresh, value: token);
  Future<String?> getAccessToken()               => _storage.read(key: _access);
  Future<String?> getRefreshToken()              => _storage.read(key: _refresh);

  // ── User meta ─────────────────────────────────────────────────
  Future<void>    saveUserRole(String role)      => _storage.write(key: _role,   value: role);
  Future<String?> getUserRole()                  => _storage.read(key: _role);
  Future<void>    saveUserId(String id)          => _storage.write(key: _userId, value: id);
  Future<String?> getUserId()                    => _storage.read(key: _userId);

  // ── Clear ─────────────────────────────────────────────────────
  Future<void> clearAll() => _storage.deleteAll();

  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

final secureStorageProvider = Provider<SecureStorage>((ref) =>
  SecureStorage(const FlutterSecureStorage()));
