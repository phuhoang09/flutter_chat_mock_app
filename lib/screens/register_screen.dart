import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/screens/otp_screen.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import '../theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isValidVietnamPhone(String phoneNumber) {
    final RegExp regex = RegExp(
      r'^(0)(3[2-9]|5[2-9]|7[0-9]|8[1-9]|9[0-9])[0-9]{7}$',
    );
    return regex.hasMatch(phoneNumber);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  void validateRegistration(
    String phoneNumber,
    String password,
    String confirmPassword,
  ) {
    if (phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ thông tin.');
      return;
    }

    if (!isValidVietnamPhone(phoneNumber)) {
      _showMessage('Số điện thoại không hợp lệ');
      return;
    }

    if (!isValidPassword(password)) {
      _showMessage('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Mật khẩu không khớp.');
      return;
    }
  }

  Future<void> _sendOtpAndNavigate(phoneNumber, password) async {
    setState(() => isLoading = true);

    try {
      await ApiService.sendOtp(phoneNumber); // Gửi OTP đến backend

      // Thành công → chuyển sang màn hình nhập OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OtpScreen(phoneNumber: phoneNumber, password: password),
        ),
      );
    } catch (e) {
      // Nếu thất bại, hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gửi OTP thất bại: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tạo Tài Khoản')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add_alt_1,
                size: 80,
                color: AppColors.appBar,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu (chứa ít nhất 6 ký tự)',
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          final phoneNumber = _phoneNumberController.text
                              .trim();
                          final password = _passwordController.text.trim();
                          final confirmPassword = _confirmPasswordController
                              .text
                              .trim();
                          validateRegistration(
                            phoneNumber,
                            password,
                            confirmPassword,
                          );
                          _sendOtpAndNavigate(phoneNumber, password);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sendButton,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Tạo Tài Khoản',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Quay lại đăng nhập',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
