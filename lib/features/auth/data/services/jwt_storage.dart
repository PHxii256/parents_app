import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists JWT tokens in the device's secure enclave (Keystore on Android,
/// Keychain on iOS). All reads/writes are async.
class JwtStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final _storage = const FlutterSecureStorage();

  /// Saves both tokens, overwriting any previously stored values.
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  /// Returns both tokens if they exist, or null if either is missing.
  Future<({String accessToken, String refreshToken})?> load() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    if (access == null || refresh == null) return null;
    return (accessToken: access, refreshToken: refresh);
  }

  /// Removes all entries from secure storage (used on logout).
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
