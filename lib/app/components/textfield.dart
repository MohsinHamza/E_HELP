import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool isPasswordField;
  final bool passwordVisibility;
  final bool enabled;
  final bool obscureText;
  final FocusNode? focusNode;
  final int maxLines;
  final double? roundedradius;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? passwordVisibilityToggle;
  final AutovalidateMode? autovalidateMode;
  final Color? borderColor;
  final bool readyOnly;
  const PrimaryTextField({
    this.controller,
    this.textStyle,
    this.roundedradius,
    this.validator,
    this.hintText: "Please write here...",
    this.hintStyle,
    this.autofillHints,
    this.maxLines: 1,
    this.keyboardType,
    this.contentPadding,
    this.isPasswordField: false,
    this.passwordVisibility: false,
    this.obscureText: false,
    this.readyOnly = false,
    this.enabled: true,
    this.passwordVisibilityToggle,
    this.autovalidateMode,
    this.focusNode,
    this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      maxLines: maxLines,
      autovalidateMode: autovalidateMode,
      controller: controller,
      validator: validator,
      obscureText: obscureText && !passwordVisibility,
      enabled: enabled,
      readOnly: readyOnly,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      style:textStyle?? hintStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,

        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedradius??21.r),
          borderSide:  BorderSide(color:borderColor?? Colors.grey, width: 0.0),
        ),
        disabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedradius??21.r),
          borderSide:  BorderSide(color: borderColor?? Colors.grey, width: 0.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundedradius??21.r),
        ),
        contentPadding: contentPadding ?? EdgeInsets.all(25.r),
        suffixIcon: !isPasswordField
            ? null
            : passwordVisibility
            ? GestureDetector(
            onTap: passwordVisibilityToggle,
            child: Icon(Icons.remove_red_eye_outlined))
            : GestureDetector(
            onTap: passwordVisibilityToggle,
            child: Icon(Icons.remove_red_eye)),
      ),
    );
  }
}