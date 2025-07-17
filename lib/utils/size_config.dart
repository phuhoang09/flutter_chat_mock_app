import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidthRatio;
  static late double scaleHeightRatio;

  static const double designWidth = 375;
  static const double designHeight = 812;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    scaleWidthRatio = screenWidth / designWidth;
    scaleHeightRatio = screenHeight / designHeight;
  }

  static double scaleWidth(double width) => width * scaleWidthRatio;
  static double scaleHeight(double height) => height * scaleHeightRatio;
  static double scaleFont(double fontSize) => fontSize * scaleWidthRatio;
}
