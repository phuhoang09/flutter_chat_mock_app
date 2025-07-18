import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://18.138.61.29:3000',
      //baseUrl: 'http://192.168.1.3:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status != null && status >= 200 && status < 500;
        // Cho phép mọi status từ 200 đến 499 => 404 sẽ không bị throw
      },
    ),
  );

  static Future<Response> login(String phoneNumber, String password) {
    return _dio.post(
      '/v1/api/app/auth/login',
      // '/users/login',
      options: Options(headers: {'system': 'capcat_app'}),
      data: {'account_name': phoneNumber, 'password': password},
    );
  }

  static Future<Response> register(
    String phoneNumber,
    String password,
    String otp,
  ) {
    return _dio.post(
      '/v1/api/app/auth/register',
      // '/users/create',
      options: Options(headers: {'system': 'capcat_app'}),
      data: {
        'account_name': phoneNumber,
        'email': '',
        'password': password,
        'otp_code': otp,
      },
    );
  }

  static Future<void> sendOtp(String phone) async {
    try {
      final response = await _dio.post(
        '/v1/api/app/auth/request-otp',
        data: {'phone': phone, "type": "REGISTER"},
      );
      if (response.statusCode != 201) {
        throw Exception('Gửi OTP thất bại');
      }
    } catch (e) {
      print("Lỗi gửi OTP: $e");
      rethrow;
    }
  }

  static Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Lỗi xác minh OTP: $e");
      return false;
    }
  }

  static Future<Response> socialLogin(
    String firebaseUid,
    String socialPlatform,
    String expTimeInString,
  ) {
    return _dio.post(
      '/v1/api/app/auth/social-login',
      options: Options(headers: {'system': 'capcat_app'}),
      data: {
        'external_id': firebaseUid,
        'provider': socialPlatform,
        'expires_at': expTimeInString,
      },
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
}
