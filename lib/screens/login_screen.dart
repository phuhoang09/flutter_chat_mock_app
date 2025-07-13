import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/data/sample_users.dart';
import 'package:flutter_chat_mock_app/models/user.dart';
import 'package:flutter_chat_mock_app/routes/fade_page_route.dart';
import 'package:flutter_chat_mock_app/screens/main_screen.dart';
import 'package:flutter_chat_mock_app/screens/register_screen.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/google_sign_in_service.dart';
import '../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  final bool _isLocalTest = false;

  void _attemptLogin(phoneNumber, password) {
    final matchedUsers = sampleUsers.where(
      (u) => u.phoneNumber == phoneNumber && u.password == password,
    );

    final User? user = matchedUsers.isNotEmpty ? matchedUsers.first : null;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tài khoản hoặc mật khẩu không đúng')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/images/cat_head_purple.png',
              //   width: 160,
              //   height: 160,
              // ),
              Icon(Icons.pets_rounded, color: AppColors.appBar, size: 200),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                //onPressed: _attemptLogin,
                onPressed: () {
                  final phoneNumber = _phoneNumberController.text.trim();
                  final password = _passwordController.text.trim();

                  if (_isLocalTest) {
                    _attemptLogin(phoneNumber, password);
                  } else {
                    AuthService.loginAndNavigate(
                      context,
                      phoneNumber,
                      password,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sendButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final userCredential =
                      await GoogleSignInService.signInWithGoogle();
                  if (userCredential != null) {
                    GoogleSignInService.printFirebaseIdToken();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                  } else {
                    // Người dùng đã huỷ
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Đăng nhập bằng Google'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(FadePageRoute(page: const RegisterScreen()));
                },
                child: const Text(
                  'Tạo Tài Khoản',
                  style: TextStyle(
                    color: AppColors.sendButton,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
