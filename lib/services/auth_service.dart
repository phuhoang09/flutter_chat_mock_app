import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import '../screens/main_screen.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  static Future<void> registerAndNavigate(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      final response = await ApiService.register(username, password);
      if (response.statusCode == 201) {
        await loginAndNavigate(context, username, password);
      } else {
        _showErrorDialog(context, 'Không thể tạo tài khoản');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Lỗi kết nối';
      _showErrorDialog(context, message);
    } catch (_) {
      _showErrorDialog(context, 'Lỗi không xác định');
    }
  }

  /// Gửi yêu cầu đăng nhập và điều hướng nếu thành công
  static Future<void> loginAndNavigate(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      final response = await ApiService.login(username, password);
      print(response);

      if (response.statusCode == 201) {
        // Giả sử backend trả về access token trong response.body
        final token =
            response.data['access_token']; // Bạn cần xử lý JSON nếu cần
        print(token);
        //         final json = jsonDecode(response.body);
        // final token = json['token'];

        await saveToken(token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        _showErrorDialog(context, 'Sai thông tin đăng nhập');
      }
    } catch (e) {
      _showErrorDialog(context, 'Không thể kết nối đến máy chủ');
    }
  }

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

  /// Hiển thị dialog lỗi
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
