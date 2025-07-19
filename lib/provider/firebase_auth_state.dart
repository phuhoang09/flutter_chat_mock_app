import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final User? firebaseUser;
  final IdTokenResult? idTokenResult;

  const AuthState({this.firebaseUser, this.idTokenResult});

  bool get isLoggedIn => firebaseUser != null && idTokenResult != null;
}
