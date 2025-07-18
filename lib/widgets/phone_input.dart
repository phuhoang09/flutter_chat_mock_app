// 📄 shared/phone_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({super.key});

  @override
  Widget build(BuildContext context) {
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
                  hintText: '988543358',
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
}
