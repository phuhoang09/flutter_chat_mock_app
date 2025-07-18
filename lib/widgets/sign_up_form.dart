// 📄 forms/sign_up_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/splash_action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/phone_input.dart';

class SignUpForm extends StatelessWidget {
  final VoidCallback onSubmitted;
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;
  const SignUpForm({
    super.key,
    required this.onSubmitted,
    required this.changeSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sign_up_form'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const InputField(hintText: "Tên của bạn", icon: Icons.person),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        const PhoneInput(),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        const InputField(hintText: "Mật khẩu", icon: Icons.lock),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        const InputField(hintText: "Nhập lại mật khẩu", icon: Icons.lock),
        SizedBox(height: SizeConfig.scaleHeight(24)),
        SplashActionButton(
          text: "Đăng ký",
          color: AppColors.orange,
          onTap: onSubmitted,
        ),
      ],
    );
  }
}
