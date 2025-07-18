// 📄 forms/sign_in_form.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/enums/social_login_status.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/services/firebase_auth_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/dialog_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/splash_action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/phone_input.dart';

class SignInForm extends StatelessWidget {
  final VoidCallback onSubmitted;
  final void Function()? onSocialLoginSuccess;
  final void Function()? onSocialLoginNotFound;
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;
  const SignInForm({
    super.key,
    required this.onSubmitted,
    this.onSocialLoginSuccess,
    this.onSocialLoginNotFound,
    required this.changeSheet,
  });

  Future<void> _handleSocialLogin(
    BuildContext context,
    String socialPlatform,
  ) async {
    final (status, response) = await FirebaseAuthService.signInWithFirebase(
      context,
      socialPlatform,
    );
    switch (status) {
      case SocialLoginStatus.success:
        // if (context.mounted) {
        onSocialLoginSuccess?.call();
      // }

      case SocialLoginStatus.accountNotFound:
        onSocialLoginNotFound?.call();

      case SocialLoginStatus.userCancelled:
        // if (context.mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Đã huỷ đăng nhập',
          message: '',
        );
      // }

      case SocialLoginStatus.invalidToken:
        // if (context.mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Token không hợp lệ',
          message: '',
        );
      // }

      case SocialLoginStatus.networkError:
        // if (context.mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Lỗi mạng',
          message: 'Không thể kết nối đến máy chủ',
        );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sign_in_form'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _WelcomeText(),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        const PhoneInput(),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        const InputField(hintText: "Mật khẩu", icon: Icons.lock),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        _buildForgotPasswordClickableText(context),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        SplashActionButton(
          text: "Đăng nhập",
          color: AppColors.orange,
          onTap: onSubmitted,
        ),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        const _DividerWithText(),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        SplashActionButton(
          icon: Image.asset('assets/images/google_button_logo.png'),
          text: 'Đăng nhập bằng Google',
          color: AppColors.white,
          onTap: () => _handleSocialLogin(context, SocialPlatform.google.value),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordClickableText(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Quên mật khẩu? ',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'Quicksand',
          fontSize: SizeConfig.scaleFont(12),
          color: const Color(0xFF1F2029),
        ),
        children: [
          TextSpan(
            text: 'Nhấn vào đây',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Quicksand',
              fontSize: SizeConfig.scaleFont(12),
              color: const Color(0xFF1F2029),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                changeSheet(SplashActionSheet.forgotPasswordEnterPhone);
              },
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chào Mừng Quay Lại!',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.scaleFont(24),
            color: Color(0xFF161616),
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(8)),
        Text(
          'Nhập thông tin đăng nhập của bạn để tiếp tục.',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.scaleFont(12),
            letterSpacing: 0.2,
            color: Color(0xFF7B7B8D),
          ),
        ),
      ],
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: Color(0xFFF5F5F5), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Hoặc',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: SizeConfig.scaleFont(12),
              color: Color(0xFF494C58),
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFF5F5F5), thickness: 1)),
      ],
    );
  }
}
