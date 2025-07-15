import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  /// Lưu access token một cách bảo mật
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Lấy access token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Xoá access token
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
