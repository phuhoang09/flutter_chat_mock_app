import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/utils/dialog_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/final_action_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/forgot_password_enter_phone_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/forgot_password_sent_new_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/intro_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/phone_register_enter_otp_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/sign_in_up_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/social_register_enter_otp_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/social_register_enter_phone_sheet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _animate = false;
  late final AnimationController _actionSheetController;
  late final Animation<Offset> _slideAnimation;

  late final AnimationController _pageAnimationController;
  late Animation<Offset> _currentPageOffset;
  late Animation<Offset> _nextPageOffset;

  int _currentIndex = 0;
  int _nextIndex = 0;
  bool _isAnimating = false;
  bool _isForward = true;

  int _signInUpFormTabIndex = 0;
  Map<String, dynamic>? _currentCustomDataMap;

  late List<Widget?> _sheets;

  @override
  void initState() {
    super.initState();

    _sheets = List<Widget?>.filled(SplashActionSheet.values.length, null);
    _sheets[0] = IntroSheet(changeSheet: _changeSheet);

    _actionSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: TransitionConfig.durationLong),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _actionSheetController,
            curve: Curves.easeInOut,
          ),
        );

    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: TransitionConfig.durationShort),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SizeConfig.init(context);
      precacheImage(
        const AssetImage('assets/images/splash_screen_logo.png'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/splash_screen_doggo.png'),
        context,
      );
    });

    Timer(const Duration(seconds: 4), () {
      setState(() => _animate = true);
      _actionSheetController.forward();
    });
  }

  void _changeSheet(
    SplashActionSheet next, {
    int? formTabIndex,
    Map<String, dynamic>? customDataMap,
  }) {
    if (_isAnimating || next.index == _currentIndex) return;

    if (formTabIndex != null && next == SplashActionSheet.signInUp) {
      _signInUpFormTabIndex = formTabIndex;
    }

    if (customDataMap != null) {
      _currentCustomDataMap = customDataMap;
    }

    _sheets[next.index] ??= _buildSheetFor(next);

    setState(() {
      _nextIndex = next.index;
      _isForward = _nextIndex > _currentIndex;
      _isAnimating = true;
    });

    _currentPageOffset =
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset(_isForward ? -1 : 1, 0),
        ).animate(
          CurvedAnimation(
            parent: _pageAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _nextPageOffset =
        Tween<Offset>(
          begin: Offset(_isForward ? 1 : -1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _pageAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _pageAnimationController.forward(from: 0).then((_) {
      setState(() {
        _currentIndex = _nextIndex;
        _isAnimating = false;
      });
    });
  }

  Widget _buildSheetFor(SplashActionSheet sheet) {
    switch (sheet) {
      case SplashActionSheet.intro:
        return IntroSheet(changeSheet: _changeSheet);
      case SplashActionSheet.signInUp:
        return SignInUpSheet(
          changeSheet: _changeSheet,
          initialFormTabIndex: _signInUpFormTabIndex,
          onPhoneLoginSuccess: _onPhoneLoginSuccess,
          onPhoneRegisterSuccess: _onPhoneRegisterSuccess,
          onSocialLoginSuccess: _onSocialLoginSuccess,
          onSocialRegisterSuccess: _onSocialRegisterSuccess,
        );
      case SplashActionSheet.forgotPasswordEnterPhone:
        return ForgotPasswordEnterPhoneSheet(changeSheet: _changeSheet);
      case SplashActionSheet.forgotPasswordSentNew:
        return ForgotPasswordSentNewSheet(changeSheet: _changeSheet);
      case SplashActionSheet.phoneRegisterEnterOtp:
        return PhoneRegisterEnterOtpSheet(
          changeSheet: _changeSheet,
          customDataMap: _currentCustomDataMap,
          onPhoneRegisterSuccess: _onPhoneRegisterSuccess,
        );
      case SplashActionSheet.socialRegisterEnterPhone:
        return SocialRegisterEnterPhoneSheet(
          changeSheet: _changeSheet,
          customDataMap: _currentCustomDataMap,
        );
      case SplashActionSheet.socialRegisterEnterOtp:
        return SocialRegisterEnterOtpSheet(
          changeSheet: _changeSheet,
          customDataMap: _currentCustomDataMap,
          onSocialRegisterSuccess: _onSocialRegisterSuccess,
        );
      case SplashActionSheet.finalStep:
        return FinalActionSheet(changeSheet: _changeSheet);
    }
  }

  Widget _buildCurrentSheet() {
    if (!_isAnimating) return _sheets[_currentIndex]!;

    return Stack(
      children: [
        SlideTransition(
          position: _currentPageOffset,
          child: _sheets[_currentIndex]!,
        ),
        SlideTransition(position: _nextPageOffset, child: _sheets[_nextIndex]!),
      ],
    );
  }

  void _onPhoneLoginSuccess() {
    DialogUtils.showErrorDialog(
      context,
      title: 'Đăng nhập số điện thoại thành công',
      message: '',
    );
  }

  void _onPhoneRegisterSuccess() {
    DialogUtils.showErrorDialog(
      context,
      title: 'Đăng ký số điện thoại thành công',
      message: '',
    );
  }

  void _onSocialLoginSuccess() {
    DialogUtils.showErrorDialog(
      context,
      title: 'Đăng nhập mạng xã hội thành công',
      message: '',
    );
  }

  void _onSocialRegisterSuccess() {
    DialogUtils.showErrorDialog(
      context,
      title: 'Đăng ký mạng xã hội thành công',
      message: '',
    );
  }

  @override
  void dispose() {
    _actionSheetController.dispose();
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final topHeight = SizeConfig.scaleHeight(213);
    final safeTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(
              milliseconds: TransitionConfig.durationLong,
            ),
            curve: Curves.easeInOut,
            top: _animate ? safeTop : topHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/splash_screen_doggo.png',
                  width: SizeConfig.scaleWidth(375),
                  fit: BoxFit.fill,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(
              milliseconds: TransitionConfig.durationLong,
            ),
            curve: Curves.easeInOut,
            top: _animate ? -topHeight : safeTop,
            left: 0,
            right: 0,
            height: topHeight,
            child: Center(
              child: Image.asset(
                'assets/images/splash_screen_logo.png',
                width: SizeConfig.scaleWidth(240),
                height: SizeConfig.scaleHeight(80),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: _buildCurrentSheet(),
          ),
        ],
      ),
    );
  }
}
