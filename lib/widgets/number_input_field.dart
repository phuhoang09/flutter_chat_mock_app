import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class NumberInputField extends StatelessWidget {
  final String hintText;
  // final IconData icon;

  const NumberInputField({
    super.key,
    required this.hintText,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
          // Icon(icon, color: const Color(0xFF9E9E9E), size: 24),
          // SizedBox(width: SizeConfig.scaleWidth(12)),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
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
        ],
      ),
    );
  }
}
