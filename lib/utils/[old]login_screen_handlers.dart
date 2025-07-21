import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_status.dart';
import 'package:flutter_chat_mock_app/screens/main_screen.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/firebase_auth_service.dart';
import 'dialog_utils.dart';

class LoginScreenHandlers {
  // static Future<SocialLoginStatus> handleSocialLogin(
  //   BuildContext context,
  //   String socialPlatform,
  // ) async {
  //   final (status, response) = await FirebaseAuthService.signInWithFirebase(
  //     context,
  //     socialPlatform,
  //   );
  //   return status;

  //   // switch (status) {
  //   //   case SocialLoginStatus.success:
  //   //     if (context.mounted) {
  //   //       Navigator.pushReplacement(
  //   //         context,
  //   //         MaterialPageRoute(builder: (_) => const MainScreen()),
  //   //       );
  //   //     }
  //   //     return true;

  //   //   case SocialLoginStatus.userCancelled:
  //   //     if (context.mounted) {
  //   //       DialogUtils.showErrorDialog(
  //   //         context,
  //   //         title: 'Đã huỷ đăng nhập',
  //   //         message: '',
  //   //       );
  //   //     }
  //   //     return false;

  //   //   case SocialLoginStatus.invalidToken:
  //   //     if (context.mounted) {
  //   //       DialogUtils.showErrorDialog(
  //   //         context,
  //   //         title: 'Token không hợp lệ',
  //   //         message: '',
  //   //       );
  //   //     }
  //   //     return false;

  //   //   case SocialLoginStatus.networkError:
  //   //     if (context.mounted) {
  //   //       DialogUtils.showErrorDialog(
  //   //         context,
  //   //         title: 'Lỗi mạng',
  //   //         message: 'Không thể kết nối đến máy chủ',
  //   //       );
  //   //     }
  //   //     return false;
  //   // }
  // }

  static Future<void> handleLoginPhone(
    BuildContext context,
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await ApiService.login(phoneNumber, password);
      final token = response.data['access_token'];
      await AuthService.saveToken(token);
      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Sai thông tin đăng nhập',
          message: '',
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          title: 'Lỗi mạng',
          message: 'Không thể kết nối đến máy chủ',
        );
      }
    } catch (_) {
      DialogUtils.showErrorDialog(
        context,
        title: 'Lỗi không xác định',
        message: '',
      );
    }
  }
}
