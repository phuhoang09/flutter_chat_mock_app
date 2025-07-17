import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_sction_sheet.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class SignInUpActionSheet extends StatefulWidget {
  final void Function(SplashActionSheet nextSheet) changeSheet;
  const SignInUpActionSheet({super.key, required this.changeSheet});

  @override
  State<SignInUpActionSheet> createState() => _SignInUpActionSheetState();
}

class _SignInUpActionSheetState extends State<SignInUpActionSheet> {
  int _selectedTabIndex = 1;

  @override
  Widget build(BuildContext context) {
    final sheetWidth = SizeConfig.scaleWidth(375);
    final sheetHeight = SizeConfig.scaleHeight(636);
    final bulletSize = SizeConfig.scaleHeight(80);
    final bulletInner = SizeConfig.scaleHeight(64);
    final borderRadius = Radius.circular(SizeConfig.scaleWidth(26));

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Action Sheet
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
                SizedBox(
                  width: SizeConfig.scaleWidth(327),
                  height: SizeConfig.scaleHeight(488),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTabSelector(),
                      SizedBox(height: SizeConfig.scaleHeight(24)),
                      _buildInputFields(),
                    ],
                  ),
                ),
                _buildLoginButton(),
              ],
            ),
          ),

          // Bullet backdrop
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

          // Bullet icon
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
    );
  }

  Widget _buildTabSelector() {
    final tabCount = 2;
    final totalWidth = SizeConfig.scaleWidth(327);
    final tabWidth = (totalWidth - SizeConfig.scaleWidth(16)) / tabCount;

    return Container(
      width: totalWidth,
      height: SizeConfig.scaleHeight(56),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(56)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: _selectedTabIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: tabWidth,
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(8),
              ),
              height: SizeConfig.scaleHeight(40),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(32)),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: SizeConfig.scaleWidth(8)),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildTabItem(
                      "Đăng Nhập",
                      selected: _selectedTabIndex == 0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 1),
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildTabItem(
                      "Đăng Ký",
                      selected: _selectedTabIndex == 1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, {bool selected = false}) {
    return Container(
      height: SizeConfig.scaleHeight(40),
      // color: Colors.red,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          fontSize: SizeConfig.scaleFont(16),
          color: selected ? const Color(0xFF0E333C) : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildInput("Tên của bạn", icon: Icons.person),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        _buildPhoneInput(),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        _buildInput("Mật khẩu", icon: Icons.lock),
        SizedBox(height: SizeConfig.scaleHeight(16)),
        _buildInput("Nhập lại mật khẩu", icon: Icons.lock),
      ],
    );
  }

  Widget _buildInput(String hintText, {required IconData icon}) {
    return Container(
      width: SizeConfig.scaleWidth(327),
      height: SizeConfig.scaleHeight(56),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9E9E9E), size: 24),
          SizedBox(width: SizeConfig.scaleWidth(12)),
          Text(
            hintText,
            style: TextStyle(
              fontSize: SizeConfig.scaleFont(14),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7B7B8D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    final height = SizeConfig.scaleHeight(56);
    final dividerHeight = SizeConfig.scaleHeight(24);
    final flagWidth = SizeConfig.scaleWidth(24);
    final flagHeight = SizeConfig.scaleWidth(16);
    final iconSize = SizeConfig.scaleWidth(16);

    return Container(
      width: SizeConfig.scaleWidth(327),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          SizedBox(width: SizeConfig.scaleWidth(16)),
          SizedBox(
            height: SizeConfig.scaleWidth(24),
            width: SizeConfig.scaleWidth(87),
            child: InkWell(
              onTap: () {
                // TODO: show modal bottom sheet chọn mã vùng
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/flags/VN.png',
                    width: flagWidth,
                    height: flagHeight,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(8)),
                  Text(
                    '+84',
                    style: TextStyle(
                      fontSize: SizeConfig.scaleFont(14),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF39434F),
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(4)),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    size: iconSize,
                    color: const Color(0xFF9E9E9E),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: dividerHeight,
            color: const Color(0xFFDADADA),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: SizeConfig.scaleWidth(16)),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '945111111',
                  hintStyle: TextStyle(
                    fontSize: SizeConfig.scaleFont(14),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7B7B8D),
                  ),
                ),
                style: TextStyle(
                  fontSize: SizeConfig.scaleFont(14),
                  color: const Color(0xFF39434F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        widget.changeSheet(SplashActionSheet.permission);
      },
      child: Container(
        width: SizeConfig.scaleWidth(327),
        height: SizeConfig.scaleHeight(54),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB085),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          "Đăng ký",
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
}
