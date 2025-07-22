import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/otp_type.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/splash_action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/phone_input.dart';

class SignUpForm extends StatefulWidget {
  final void Function(
    SplashActionSheet next, {
    int? formTabIndex,
    Map<String, dynamic> customDataMap,
  })
  changeSheet;

  const SignUpForm({super.key, required this.changeSheet});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegisterButtonTap() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    if (!isValidRegistration(phone, password, confirmPassword)) {
      return;
    }
    bool didSendOtpSuccess = await ApiService.requestOtp(
      phone,
      OtpType.register.value,
    );
    if (didSendOtpSuccess) {
      Map<String, dynamic> dataMap = {
        'name': name,
        'phone': phone,
        'password': password,
      };
      widget.changeSheet(
        SplashActionSheet.phoneRegisterEnterOtp,
        customDataMap: dataMap,
      );
    }
  }

  bool isValidVietnamPhone(String phoneNumber) {
    final RegExp regex = RegExp(
      r'^\+84(3[2-9]|5[2-9]|7[0-9]|8[1-9]|9[0-9])[0-9]{7}$',
    );
    return regex.hasMatch(phoneNumber);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  bool isValidRegistration(
    String phoneNumber,
    String password,
    String confirmPassword,
  ) {
    if (phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ thông tin.');
      return false;
    }

    if (!isValidVietnamPhone(phoneNumber)) {
      _showMessage('Số điện thoại không hợp lệ');
      return false;
    }

    if (!isValidPassword(password)) {
      _showMessage('Mật khẩu phải có ít nhất 6 ký tự');
      return false;
    }

    if (password != confirmPassword) {
      _showMessage('Mật khẩu không khớp.');
      return false;
    }
    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sign_up_form'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InputField(
          hintText: "Tên của bạn",
          icon: Icons.person,
          controller: _nameController,
        ),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        PhoneInput(
          onChanged: (fullPhoneNumber) {
            _phoneController.text = fullPhoneNumber;
          },
        ),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        InputField(
          hintText: "Mật khẩu",
          icon: Icons.lock,
          controller: _passwordController,
          obscureText: true,
        ),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        InputField(
          hintText: "Nhập lại mật khẩu",
          icon: Icons.lock,
          controller: _confirmPasswordController,
          obscureText: true,
        ),
        SizedBox(height: SizeConfig.scaleHeight(24)),
        SplashActionButton(
          text: "Đăng ký",
          color: AppColors.orange,
          onTap: () {
            _handleRegisterButtonTap();
          },
        ),
      ],
    );
  }
}
