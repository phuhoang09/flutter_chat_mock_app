import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/enums/social_login_status.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/google_auth_service.dart';

class FirebaseAuthService {
  static Future<(SocialLoginStatus, Response?)> signInWithFirebase(
    BuildContext context,
    String socialPlatform,
  ) async {
    OAuthCredential? oAuthCredential;
    if (socialPlatform == SocialPlatform.google.value) {
      oAuthCredential = await GoogleAuthService.signInGoogle();
    }
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(oAuthCredential!);
    User? user = userCredential.user;
    if (user == null) return (SocialLoginStatus.userCancelled, null);
    try {
      final idTokenResult = await user.getIdTokenResult();
      final userId = idTokenResult.claims?["user_id"];
      final expirationTimeInSecs = idTokenResult.claims?["exp"];
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        expirationTimeInSecs * 1000,
        isUtc: true,
      );
      final iso8601String = dateTime.toIso8601String();

      if (userId == null || expirationTimeInSecs == null) {
        return (SocialLoginStatus.invalidToken, null);
      }

      final response = await ApiService.socialLogin(
        userId,
        socialPlatform,
        iso8601String,
      );

      debugPrint("ApiService.socialLogin: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (SocialLoginStatus.success, response);
      }

      if (response.statusCode == 404 &&
          (response.data['error'] == 'account_not_found')) {
        return (SocialLoginStatus.accountNotFound, response);
      }

      return (SocialLoginStatus.networkError, response); // fallback
    } catch (e) {
      debugPrint("Firebase signInWithFirebase error: $e");
      return (SocialLoginStatus.networkError, null);
    }
  }
}
