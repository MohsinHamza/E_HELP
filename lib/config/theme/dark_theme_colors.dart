import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';

class DarkThemeColors
{
  //dark swatch
  static const Color primaryColor = AppColors.lightRed;
  static Color accentColor = AppColors.darkRed;

  //Appbar
  static const Color appbarColor = Colors.white;

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Color(0xff171d2d);
  static const Color backgroundColor = Color(0xff171d2d);
  static const Color dividerColor = Color(0xff686868);
  static const Color cardColor = Color(0xff1e2336);

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = primaryColor;

  //BUTTON
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.black;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Colors.white70;
  static const Color headlinesTextColor = primaryColor;
  static const Color captionTextColor = Colors.grey;
  static const Color hintTextColor = Color(0xff686868);

  //chip
  static const Color chipBackground = primaryColor;
  static const Color chipTextColor = Colors.black87;

  // progress bar indicator
  static const Color progressIndicatorColor = Color(0xFF40A76A);
}