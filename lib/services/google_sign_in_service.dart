import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // User canceled

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> printFirebaseIdToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userJsonString = jsonEncode(user);
      print(userJsonString);
      final idToken = await user
          .getIdToken(); // hoặc getIdToken(true) để refresh
      print("Firebase ID Token: $idToken");
    } else {
      print("Chưa đăng nhập.");
    }
  }
}
