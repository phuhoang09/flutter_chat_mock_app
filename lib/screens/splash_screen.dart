import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_sction_sheet.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/final_action_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/intro_action_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/sign_in_up_action_sheet.dart';
// import 'auth_check_screen.dart';

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
  SplashActionSheet _currentSheet = SplashActionSheet.intro;

  @override
  void initState() {
    super.initState();

    /// B1: Khởi tạo controller + animation TRƯỚC khi build dùng
    _actionSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _actionSheetController,
            curve: Curves.easeOutQuart,
          ),
        );

    /// B2: Init size config
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SizeConfig.init(context);
    });

    /// B3: Trigger animation sau 4s
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
    super.dispose();
  }

  Widget _buildActionSheet() {
    switch (_currentSheet) {
      case SplashActionSheet.intro:
        return IntroActionSheet(changeSheet: _changeSheet);
      case SplashActionSheet.permission:
        return SignInUpActionSheet(changeSheet: _changeSheet);
      case SplashActionSheet.finalStep:
        return FinalActionSheet(changeSheet: _changeSheet);
    }
  }

  void _changeSheet(SplashActionSheet next) {
    setState(() {
      _currentSheet = next;
    });
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
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
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
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
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
            child: _buildActionSheet(),
          ),
        ],
      ),
    );
  }
}
