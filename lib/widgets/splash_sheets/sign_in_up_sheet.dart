import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';
import 'package:flutter_chat_mock_app/widgets/sign_in_form.dart';
import 'package:flutter_chat_mock_app/widgets/sign_up_form.dart';
import '../tab_selector.dart';

class SignInUpSheet extends StatefulWidget {
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;
  final int initialFormTabIndex;

  const SignInUpSheet({
    super.key,
    required this.changeSheet,
    this.initialFormTabIndex = 0,
  });

  @override
  State<SignInUpSheet> createState() => _SignInUpSheetState();
}

class _SignInUpSheetState extends State<SignInUpSheet> {
  late int _selectedTabIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialFormTabIndex;
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  void _onSocialLoginSuccess() {
    widget.changeSheet(SplashActionSheet.finalStep);
  }

  void _onSocialLoginNotFound() {
    widget.changeSheet(SplashActionSheet.signInUp, formTabIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final sheetWidth = SizeConfig.scaleWidth(375);
    final sheetHeight = SizeConfig.scaleHeight(636);
    final bulletSize = SizeConfig.scaleHeight(80);
    final bulletInner = SizeConfig.scaleHeight(64);
    final borderRadius = Radius.circular(SizeConfig.scaleWidth(26));

    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: sheetWidth,
              height: sheetHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(50, 50, 71, 0.02),
                    offset: Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(12, 26, 75, 0.1),
                    offset: Offset(0, 0),
                    blurRadius: 8,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius,
                  topRight: borderRadius,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: bulletSize / 2),
                  Container(
                    width: SizeConfig.scaleWidth(327),
                    height: SizeConfig.scaleHeight(505),
                    child: Column(
                      children: [
                        TabSelector(
                          selectedIndex: _selectedTabIndex,
                          onTabChanged: (index) {
                            setState(() => _selectedTabIndex = index);
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(
                                milliseconds: TransitionConfig.durationShort,
                              ),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        SizedBox(height: SizeConfig.scaleHeight(24)),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              SignInForm(
                                onSubmitted: () {},
                                onSocialLoginSuccess: _onSocialLoginSuccess,
                                onSocialLoginNotFound: _onSocialLoginNotFound,
                                changeSheet: widget.changeSheet,
                              ),
                              SignUpForm(
                                changeSheet: widget.changeSheet,
                                onSubmitted: () {
                                  widget.changeSheet(
                                    SplashActionSheet.signInUp,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -bulletSize / 2,
              left: (sheetWidth - bulletSize) / 2,
              child: Container(
                width: bulletSize,
                height: bulletSize,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -bulletSize / 2,
              left: (sheetWidth - bulletSize) / 2,
              child: Container(
                width: bulletSize,
                height: bulletSize,
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: bulletInner,
                    minHeight: bulletInner,
                    maxWidth: bulletInner,
                    maxHeight: bulletInner,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: const Color(0xFFD1E6FF),
                    ),
                    borderRadius: BorderRadius.circular(bulletInner),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/icon_profile_splash.png',
                      width: SizeConfig.scaleWidth(25.5),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
