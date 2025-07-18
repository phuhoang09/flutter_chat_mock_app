// 📄 shared/cta_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class SplashActionButton extends StatelessWidget {
  final Widget? icon;
  final double iconSize;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const SplashActionButton({
    super.key,
    this.icon,
    this.iconSize = 20,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.scaleWidth(327),
        height: SizeConfig.scaleHeight(54),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.scaleWidth(iconSize),
                    height: SizeConfig.scaleWidth(iconSize),
                    child: Center(child: icon!),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(8)),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.scaleFont(14),
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            : Text(
                text,
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
