import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_status.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/google_auth_service.dart';

class FirebaseAuthService {
  static Future<(SocialLoginStatus, Response?)> signInWithFirebase(
    BuildContext context,
    String socialPlatform,
  ) async {
    User? user;

    if (socialPlatform == "GOOGLE") {
      user = await GoogleAuthService.signInGoogle();
    }

    if (user == null) return (SocialLoginStatus.userCancelled, null);

    try {
      final idTokenResult = await user.getIdTokenResult();
      final userId = idTokenResult.claims?["user_id"];
      final expirationTimeInSecs = idTokenResult.claims?["exp"];

      if (userId == null || expirationTimeInSecs == null) {
        return (SocialLoginStatus.invalidToken, null);
      }

      final response = await ApiService.loginSocial(
        userId,
        expirationTimeInSecs,
      );

      return (SocialLoginStatus.success, response);
    } catch (e) {
      debugPrint("Firebase signInWithFirebase error: $e");
      return (SocialLoginStatus.networkError, null);
    }
  }
}
