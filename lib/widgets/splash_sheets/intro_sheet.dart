import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class IntroSheet extends StatelessWidget {
  final void Function(SplashActionSheet nextSheet) changeSheet;
  const IntroSheet({super.key, required this.changeSheet});

  @override
  Widget build(BuildContext context) {
    final sheetWidth = SizeConfig.scaleWidth(375);
    final sheetHeight = SizeConfig.scaleHeight(432);
    final bulletSize = SizeConfig.scaleHeight(80);
    final bulletInner = SizeConfig.scaleHeight(64);
    final borderRadius = Radius.circular(SizeConfig.scaleWidth(26));

    return Align(
      alignment: Alignment.bottomCenter,
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
                    children: [_buildContent()],
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(16)),
                _buildButton(),
              ],
            ),
          ),
          _buildBulletBackdrop(sheetWidth, bulletSize),
          _buildBulletIcon(sheetWidth, bulletSize, bulletInner),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: SizeConfig.scaleWidth(24)),
      width: SizeConfig.scaleWidth(327),
      // height: SizeConfig.scaleHeight(240),
      //color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.scaleHeight(24)),
          _buildProgressBar(),
          SizedBox(height: SizeConfig.scaleHeight(24)),
          _buildTitleAndDescription(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBarSegment(59.67, 3, const Color(0xFFD9DFE6)),
        SizedBox(width: SizeConfig.scaleWidth(6)),
        _buildBarSegment(56.67, 6, const Color(0xFFFFB085)),
        SizedBox(width: SizeConfig.scaleWidth(6)),
        _buildBarSegment(59.67, 3, const Color(0xFFD9DFE6)),
      ],
    );
  }

  Widget _buildBarSegment(double width, double height, Color color) {
    return Container(
      width: SizeConfig.scaleWidth(width),
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Column(
      children: [
        Text(
          'Hồ sơ thú cưng cá nhân hóa',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.scaleFont(24),
            color: const Color(0xFF39434F),
            height: 34 / 24,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.scaleHeight(10)),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: SizeConfig.scaleFont(16) * 1.5 * 8,
          ),
          child: Text(
            'Tạo hồ sơ cá nhân hóa cho từng thú cưng yêu quý của bạn trên PawBuddy. Chia sẻ tên, giống, và tuổi của chúng trong khi kết nối với một cộng đồng sôi động.',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.scaleFont(16),
              color: const Color(0xFF808B9A),
              height: 24 / 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      width: SizeConfig.scaleWidth(375),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(24)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB085),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(17)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: () {
          changeSheet(SplashActionSheet.signInUp);
        },
        child: Text(
          'Bắt đầu ngay',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
            fontSize: SizeConfig.scaleFont(14),
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBulletBackdrop(double sheetWidth, double bulletSize) {
    return Positioned(
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
    );
  }

  Widget _buildBulletIcon(
    double sheetWidth,
    double bulletSize,
    double bulletInner,
  ) {
    return Positioned(
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
            border: Border.all(width: 1.5, color: const Color(0xFFD1E6FF)),
            borderRadius: BorderRadius.circular(bulletInner),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/icon_edit_splash.png',
              width: SizeConfig.scaleWidth(25.5),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
