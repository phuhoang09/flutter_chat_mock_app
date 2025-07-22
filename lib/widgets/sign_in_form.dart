import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/phone_login_status.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/enums/social_login_status.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/dialog_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/splash_action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/phone_input.dart';

class SignInForm extends StatefulWidget {
  final void Function()? onPhoneLoginSuccess;
  final void Function()? onSocialLoginSuccess;
  final void Function(Map<String, dynamic>? socialRegisterMap)?
  onSocialLoginNotFound;
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;

  const SignInForm({
    super.key,
    this.onPhoneLoginSuccess,
    this.onSocialLoginSuccess,
    this.onSocialLoginNotFound,
    required this.changeSheet,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handlePhoneLogin(
    BuildContext context,
    String phoneNumber,
    String password,
  ) async {
    final (status, response) = await AuthService.signInWithPhone(
      context,
      phoneNumber,
      password,
    );
    switch (status) {
      case PhoneLoginStatus.success:
        widget.onPhoneLoginSuccess?.call();
        break;
      case PhoneLoginStatus.accountNotFound:
        DialogUtils.showErrorDialog(
          context,
          title: 'Không tìm thấy tài khoản với số điện thoại này',
          message: '',
        );
        break;
      case PhoneLoginStatus.userCancelled:
        DialogUtils.showErrorDialog(
          context,
          title: 'Đã huỷ đăng nhập',
          message: '',
        );
        break;
      case PhoneLoginStatus.invalidToken:
        DialogUtils.showErrorDialog(
          context,
          title: 'Token không hợp lệ',
          message: '',
        );
        break;
      case PhoneLoginStatus.networkError:
        DialogUtils.showErrorDialog(
          context,
          title: 'Lỗi mạng',
          message: 'Không thể kết nối đến máy chủ',
        );
        break;
    }
  }

  Future<void> _handleSocialLogin(
    BuildContext context,
    String socialPlatform,
  ) async {
    final (status, response, socialRegisterMap) =
        await AuthService.signInWithFirebase(context, socialPlatform);
    switch (status) {
      case SocialLoginStatus.success:
        widget.onSocialLoginSuccess?.call();
        break;

      case SocialLoginStatus.accountNotFound:
        widget.onSocialLoginNotFound?.call(socialRegisterMap);
        break;

      case SocialLoginStatus.userCancelled:
        DialogUtils.showErrorDialog(
          context,
          title: 'Đã huỷ đăng nhập',
          message: '',
        );
        break;

      case SocialLoginStatus.invalidToken:
        DialogUtils.showErrorDialog(
          context,
          title: 'Token không hợp lệ',
          message: '',
        );
        break;

      case SocialLoginStatus.networkError:
        DialogUtils.showErrorDialog(
          context,
          title: 'Lỗi mạng',
          message: 'Không thể kết nối đến máy chủ',
        );
        break;
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
        PhoneInput(
          onChanged: (fullPhoneNumber) {
            setState(() => _phoneController.text = fullPhoneNumber);
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
        _buildForgotPasswordClickableText(context),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        SplashActionButton(
          text: "Đăng nhập",
          color: AppColors.orange,
          onTap: () {
            _handlePhoneLogin(
              context,
              _phoneController.text.trim(),
              _passwordController.text,
            );
          },
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
                widget.changeSheet(SplashActionSheet.forgotPasswordEnterPhone);
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
