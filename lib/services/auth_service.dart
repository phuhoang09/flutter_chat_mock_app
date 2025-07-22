import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/phone_login_status.dart';
import 'package:flutter_chat_mock_app/enums/phone_register_status.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/enums/social_login_status.dart';
import 'package:flutter_chat_mock_app/enums/social_register_status.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  static Future<void> saveToken(String token, DateTime expirationTime) async {
    final data = {
      'token': token,
      'expiration': expirationTime.toIso8601String(),
    };
    await _storage.write(key: _tokenKey, value: jsonEncode(data));
  }

  static Future<String?> getToken() async {
    final value = await _storage.read(key: _tokenKey);
    if (value == null) return null;

    try {
      final data = jsonDecode(value);
      final expiration = DateTime.parse(data['expiration']);
      if (DateTime.now().isAfter(expiration)) {
        await clearToken();
        return null;
      }
      return data['token'];
    } catch (_) {
      return value;
    }
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<(PhoneLoginStatus, Response?)> signInWithPhone(
    BuildContext context,
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await ApiService.login(phoneNumber, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(token, DateTime.parse(expiredTime));
        return (PhoneLoginStatus.success, response);
      }

      if (response.statusCode == 404 &&
          (response.data['error'] == 'account_not_found')) {
        return (PhoneLoginStatus.accountNotFound, response);
      }

      return (PhoneLoginStatus.networkError, response); // fallback
    } catch (e) {
      debugPrint("Phone Sign In error: $e");
      return (PhoneLoginStatus.networkError, null);
    }
  }

  static Future<(PhoneRegisterStatus, Response?)> registerPhone(
    BuildContext context,
    String name,
    String phoneNumber,
    String password,
    String otp,
  ) async {
    try {
      final response = await ApiService.register(
        name,
        phoneNumber,
        password,
        otp,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(token, DateTime.parse(expiredTime));
        return (PhoneRegisterStatus.success, response);
      }
      return (PhoneRegisterStatus.fail, response); // fallback
    } catch (e) {
      debugPrint("Phone Sign Up error: $e");
      return (PhoneRegisterStatus.fail, null);
    }
  }

  static Future<(SocialLoginStatus, Response?, Map<String, dynamic>?)>
  signInWithFirebase(BuildContext context, String socialPlatform) async {
    OAuthCredential? oAuthCredential;
    if (socialPlatform == SocialPlatform.google.value) {
      oAuthCredential = await signInGoogle();
    }
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(oAuthCredential!);
    User? user = userCredential.user;
    if (user == null) return (SocialLoginStatus.userCancelled, null, null);
    try {
      final idTokenResult = await user.getIdTokenResult();
      final userId = idTokenResult.claims?["user_id"];
      final expirationTimeInSecs = idTokenResult.claims?["exp"];
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        expirationTimeInSecs * 1000,
        isUtc: true,
      );
      final expTimeString = dateTime.toIso8601String();

      if (userId == null || expirationTimeInSecs == null) {
        return (SocialLoginStatus.invalidToken, null, null);
      }

      final response = await ApiService.socialLogin(
        userId,
        socialPlatform,
        expTimeString,
      );

      debugPrint("ApiService.socialLogin: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(token, DateTime.parse(expiredTime));
        return (SocialLoginStatus.success, response, null);
      }

      if (response.statusCode == 404 &&
          (response.data['error'] == 'account_not_found')) {
        final socialRegisterMap = {
          'external_id': userId,
          'provider': socialPlatform,
          'first_name': idTokenResult.claims?['name'] ?? '',
          'last_name': '',
          'avatar': idTokenResult.claims?["picture"] ?? "",
          'email': idTokenResult.claims?["email"] ?? "",
          'expires_at': expTimeString,
          // 'phone': '',
          // 'otp_code': '',
        };
        return (SocialLoginStatus.accountNotFound, response, socialRegisterMap);
      }

      return (SocialLoginStatus.networkError, response, null); // fallback
    } catch (e) {
      debugPrint("Firebase signInWithFirebase error: $e");
      return (SocialLoginStatus.networkError, null, null);
    }
  }

  static Future<(SocialRegisterStatus, Response?)> registerSocial(
    BuildContext context,
    String externalId,
    String provider,
    String firstName,
    String lastName,
    String avatar,
    String email,
    String expiresAt,
    String phone,
    String otpCode,
  ) async {
    try {
      final response = await ApiService.socialRegister(
        externalId,
        provider,
        firstName,
        lastName,
        avatar,
        email,
        expiresAt,
        phone,
        otpCode,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(token, DateTime.parse(expiredTime));
        return (SocialRegisterStatus.success, response);
      }
      return (SocialRegisterStatus.fail, response); // fallback
    } catch (e) {
      debugPrint("Phone Sign Up error: $e");
      return (SocialRegisterStatus.fail, null);
    }
  }

  static Future<OAuthCredential?> signInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // User canceled
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential googleOAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return googleOAuthCredential;
  }

  static Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
