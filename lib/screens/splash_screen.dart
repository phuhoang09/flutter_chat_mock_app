import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/final_action_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/forgot_password_enter_phone_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/forgot_password_sent_new_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/intro_action_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/splash_sheets/sign_in_up_action_sheet.dart';

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
  late final PageController _sheetPageController;
  int _currentIndex = 0;
  int _signInUpFormTabIndex = 0; // 0 = SignIn, 1 = SignUp

  @override
  void initState() {
    super.initState();

    _sheetPageController = PageController(initialPage: _currentIndex);

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
      setState(() {
        _animate = true;
      });
      _actionSheetController.forward();
    });
  }

  @override
  void dispose() {
    _actionSheetController.dispose();
    _sheetPageController.dispose();
    super.dispose();
  }

  void _changeSheet(SplashActionSheet next, {int? formTabIndex}) {
    if (formTabIndex != null && next == SplashActionSheet.signInUp) {
      _signInUpFormTabIndex = formTabIndex;
    }
    _sheetPageController.animateToPage(
      next.index,
      duration: const Duration(milliseconds: TransitionConfig.durationShort),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentIndex = next.index;
    });
  }

  Widget _buildSignInUpSheet() {
    return SignInUpActionSheet(
      changeSheet: _changeSheet,
      initialFormTabIndex: _signInUpFormTabIndex,
    );
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
          /// botPart
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

          /// topPart
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

          /// Slide lên ActionSheet
          SlideTransition(
            position: _slideAnimation,
            child: PageView(
              controller: _sheetPageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                IntroActionSheet(changeSheet: _changeSheet),
                _buildSignInUpSheet(),
                ForgotPasswordEnterPhoneSheet(changeSheet: _changeSheet),
                ForgotPasswordSentNewSheet(changeSheet: _changeSheet),
                FinalActionSheet(changeSheet: _changeSheet),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
