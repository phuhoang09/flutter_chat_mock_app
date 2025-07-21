import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/heading_with_back_arrow.dart';
import 'package:flutter_chat_mock_app/widgets/number_input_field.dart';
import 'package:flutter_chat_mock_app/widgets/splash_action_button.dart';

class SocialRegisterEnterOtpSheet extends StatefulWidget {
  final void Function(
    SplashActionSheet nextSheet, {
    int? formTabIndex,
    Map<String, dynamic>? customDataMap,
  })
  changeSheet;
  final Map<String, dynamic>? customDataMap;
  const SocialRegisterEnterOtpSheet({
    super.key,
    required this.changeSheet,
    this.customDataMap,
  });

  @override
  State<SocialRegisterEnterOtpSheet> createState() =>
      _SocialRegisterEnterOtpSheetState();
}

class _SocialRegisterEnterOtpSheetState
    extends State<SocialRegisterEnterOtpSheet> {
  Timer? _timer;
  int _remainingSeconds = 10;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 10;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _handleResendPressed() {
    if (!_canResend) return;

    /// Logic gửi lại mã (nếu có)
    debugPrint('Gửi lại mã');

    /// Sau khi gửi xong thì restart lại countdown nếu cần
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Bắt buộc phải huỷ khi thoát khỏi sheet
    super.dispose();
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
                  // Main Area Container
                  SizedBox(
                    width: SizeConfig.scaleWidth(327),
                    // height: SizeConfig.scaleHeight(240),
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HeadingWithBackArrow(
                          title: 'Nhập số điện thoại',
                          onBack: () {
                            widget.changeSheet(
                              SplashActionSheet.socialRegisterEnterPhone,
                            );
                          },
                        ),
                        SizedBox(height: SizeConfig.scaleHeight(8)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: SizeConfig.scaleFont(12) * 1.5 * 3,
                          ),
                          child: Text(
                            'Vui lòng nhập mã mà chúng mình đã gửi đến\n${widget.customDataMap?['phone']}',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.scaleFont(12),
                              letterSpacing: 0.2,
                              color: Color(0xFF7B7B8D),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.scaleHeight(16)),
                        const NumberInputField(hintText: 'Nhập mã code'),
                        SizedBox(height: SizeConfig.scaleHeight(16)),
                        TextButton(
                          onPressed: _canResend ? _handleResendPressed : null,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.scaleFont(12),
                                height: 20 / 12,
                                letterSpacing: 0.2,
                                color: const Color(0xFF99664F),
                              ),
                              children: [
                                const TextSpan(text: 'Gửi lại'),
                                if (!_canResend) ...[
                                  const TextSpan(text: ' trong '),
                                  TextSpan(
                                    text: _formatTime(_remainingSeconds),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  SplashActionButton(
                    text: 'Xác nhận',
                    color: AppColors.orange,
                    onTap: () => {
                      widget.changeSheet(
                        SplashActionSheet.signInUp,
                        formTabIndex: 0,
                      ),
                    },
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

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
