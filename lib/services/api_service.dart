import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://18.138.61.29:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<Response> login(String phoneNumber, String password) {
    return _dio.post(
      '/v1/api/app/auth/login',
      options: Options(headers: {'system': 'capcat_app'}),
      data: {'account_name': phoneNumber, 'password': password},
    );
  }

  static Future<Response> register(String phoneNumber, String password) {
    return _dio.post(
      '/v1/api/app/auth/register',
      options: Options(headers: {'system': 'capcat_app'}),
      data: {'account_name': phoneNumber, 'password': password},
    );
  }

  static Future<Response> getProfile(String token) {
    return _dio.get(
      '/profile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  static Future<Response> uploadImage(FormData formData, String token) {
    return _dio.post(
      '/upload',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Thêm các API khác tại đây...
}
