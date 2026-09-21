import 'package:fintrack/core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  Future<void> write(String token) =>
      _storage.write(key: ApiConstants.tokenKey, value: token);

  Future<String?> read() => _storage.read(key: ApiConstants.tokenKey);

  Future<void> clear() => _storage.delete(key: ApiConstants.tokenKey);
}
