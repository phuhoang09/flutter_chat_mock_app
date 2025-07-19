import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final idToken = await user.getIdTokenResult();
      return AuthState(firebaseUser: user, idTokenResult: idToken);
    }

    return const AuthState();
  }

  /// Gọi sau khi đăng nhập thành công (Google/Facebook/Email...)
  Future<void> updateFromCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdTokenResult();
      state = AsyncData(AuthState(firebaseUser: user, idTokenResult: idToken));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncData(AuthState());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
