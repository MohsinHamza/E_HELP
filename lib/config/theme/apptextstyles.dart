import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_app_colors.dart';
import 'dark_theme_colors.dart';
import 'dimensions.dart';
import 'my_fonts.dart';
import 'light_theme_colors.dart';

class AppTextStyles {
  static const kPrimaryTitle = TextStyle(
    fontSize: AppDimensions.kLargeSize,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: Color(0xff2E3E5C),
  );
  static const kPrimaryS2W4 = TextStyle(
      fontSize: AppDimensions.kMediumSize,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: AppColors.S_text);
  static const kPrimaryS3W4 = TextStyle(
    fontSize: AppDimensions.kMediumSize,
    fontWeight: FontWeight.w700,
    color: AppColors.Primary_white,
  );
  static const kPrimaryS4W4 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 17,
    color: AppColors.lightRed,
  );

  static const kPrimaryS4W1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17,
    color: AppColors.Kblue_type,
  );
  static const kPrimaryS4W5 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32,
    color: Colors.black,
  );
  static const kPrimaryS5W1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 40,
    color: AppColors.Kblue_type,
  );
  static const kPrimaryS5W2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: Colors.black,
  );
  static const kPrimaryS5W3 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 17,
  );
  static const kPrimaryS5W4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const kPrimaryS6W1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static const kPrimaryS6W3 = TextStyle(
      fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.Kblue_type);
  static const kPrimaryS6W5 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 17,
  );
  static const kPrimaryS7W1 = TextStyle(
    color: Color(0xff616161),
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
  static const kPrimaryS7W2 =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black);
  static const kPrimaryS7W3 =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey);
  static const kPrimaryS7W4 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey);
  static const kPrimaryS7W5 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);
  static const kPrimaryS5W6 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.Kblue_type);
  static const kPrimaryS8W1 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.Kred);
  static const kPrimaryS8W3 =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black);
  static const kPrimaryS9W1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colors.black,
  );
  static const kPrimaryS9W2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Color(0xff2743FD),
  );
  static const kPrimaryS9W3 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.black,
  );
  static const kPrimaryS9W4 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.grey,
  );
  static const kPrimaryS9W5 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 24,
    color: Colors.black,
  );
  static const kPrimaryS10W1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.Kblue_type,
  );
  static const kPrimaryS10W2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: Color(0xffBDBDBD),
  );
}

class MyStyles {
  ///icons theme
  static IconThemeData getIconTheme({required bool isLightTheme}) =>
      IconThemeData(
        color: isLightTheme
            ? LightThemeColors.iconColor
            : DarkThemeColors.iconColor,
      );

  ///app bar theme
  static AppBarTheme getAppBarTheme({required bool isLightTheme}) =>
      AppBarTheme(
        elevation: 0,
        titleTextStyle:
            getTextTheme(isLightTheme: isLightTheme).bodyText1!.copyWith(
                  color: Colors.white,
                  fontSize: MyFonts.appBarTittleSize,
                ),
        iconTheme: IconThemeData(
            color: isLightTheme
                ? LightThemeColors.appBarIconsColor
                : DarkThemeColors.appBarIconsColor),
        backgroundColor: isLightTheme
            ? LightThemeColors.appBarColor
            : DarkThemeColors.appbarColor,
      );

  ///text theme
  static TextTheme getTextTheme({required bool isLightTheme}) => TextTheme(
        button:
            MyFonts.buttonTextStyle.copyWith(fontSize: MyFonts.buttonTextSize),
        bodyText1: (MyFonts.bodyTextStyle).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: MyFonts.body1TextSize,
            color: isLightTheme
                ? LightThemeColors.bodyTextColor
                : DarkThemeColors.bodyTextColor),
        bodyText2: (MyFonts.bodyTextStyle).copyWith(
            fontSize: MyFonts.body2TextSize,
            color: isLightTheme
                ? LightThemeColors.bodyTextColor
                : DarkThemeColors.bodyTextColor),
        headline1: (MyFonts.headlineTextStyle).copyWith(
            fontSize: MyFonts.headline1TextSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.headlinesTextColor
                : DarkThemeColors.headlinesTextColor),
        headline2: (MyFonts.headlineTextStyle).copyWith(
            fontSize: MyFonts.headline2TextSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.headlinesTextColor
                : DarkThemeColors.headlinesTextColor),
        headline3: (MyFonts.headlineTextStyle).copyWith(
            fontSize: MyFonts.headline3TextSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.headlinesTextColor
                : DarkThemeColors.headlinesTextColor),
        headline4: (MyFonts.headlineTextStyle).copyWith(
            fontSize: MyFonts.headline4TextSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.headlinesTextColor
                : DarkThemeColors.headlinesTextColor),
        headline5: (MyFonts.headlineTextStyle).copyWith(
            fontSize: MyFonts.headline5TextSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.headlinesTextColor
                : DarkThemeColors.headlinesTextColor),
        headline6: (MyFonts.headlineTextStyle).copyWith(
            fontSize: MyFonts.headline6TextSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.headlinesTextColor
                : DarkThemeColors.headlinesTextColor),
        caption: TextStyle(
            color: isLightTheme
                ? LightThemeColors.captionTextColor
                : DarkThemeColors.captionTextColor,
            fontSize: MyFonts.captionTextSize),
      );

  static ChipThemeData getChipTheme({required bool isLightTheme}) {
    return ChipThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.chipBackground
          : DarkThemeColors.chipBackground,
      brightness: Brightness.light,
      labelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      secondaryLabelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      selectedColor: Colors.black,
      disabledColor: Colors.green,
      padding: EdgeInsets.all(5),
      secondarySelectedColor: Colors.purple,
    );
  }

  ///Chips text style
  static TextStyle getChipTextStyle({required bool isLightTheme}) {
    return MyFonts.chipTextStyle.copyWith(
      fontSize: MyFonts.chipTextSize,
      color: isLightTheme
          ? LightThemeColors.chipTextColor
          : DarkThemeColors.chipTextColor,
    );
  }

  // elevated button text style
  static MaterialStateProperty<TextStyle?>? getElevatedButtonTextStyle(
      bool isLightTheme,
      {bool isBold = true,
      double? fontSize}) {
    return MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return MyFonts.buttonTextStyle.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize ?? MyFonts.buttonTextSize,
              color: isLightTheme
                  ? LightThemeColors.buttonTextColor
                  : DarkThemeColors.buttonTextColor);
        } else if (states.contains(MaterialState.disabled)) {
          return MyFonts.buttonTextStyle.copyWith(
              fontSize: fontSize ?? MyFonts.buttonTextSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isLightTheme
                  ? LightThemeColors.buttonDisabledTextColor
                  : DarkThemeColors.buttonDisabledTextColor);
        }
        return MyFonts.buttonTextStyle.copyWith(
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isLightTheme
                ? LightThemeColors.buttonTextColor
                : DarkThemeColors
                    .buttonTextColor); // Use the component's default.
      },
    );
  }

  //elevated button theme data
  static ElevatedButtonThemeData getElevatedButtonTheme(
          {required bool isLightTheme}) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
              //side: BorderSide(color: Colors.teal, width: 2.0),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 8.h)),
          textStyle: getElevatedButtonTextStyle(isLightTheme),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return isLightTheme
                    ? LightThemeColors.buttonColor.withOpacity(0.5)
                    : DarkThemeColors.buttonColor.withOpacity(0.5);
              } else if (states.contains(MaterialState.disabled)) {
                return isLightTheme
                    ? LightThemeColors.buttonDisabledColor
                    : DarkThemeColors.buttonDisabledColor;
              }
              return isLightTheme
                  ? LightThemeColors.buttonColor
                  : DarkThemeColors.buttonColor; // Use the component's default.
            },
          ),
        ),
      );
}