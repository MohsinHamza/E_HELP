import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> dialogueCard(
    BuildContext context,
    String buttonText,
    VoidCallback onConfrim,
    String buttonText2,
    VoidCallback onConfrim2,
    ) {
  double H = MediaQuery.of(context).size.height;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.only(top: 16.0, right: 16.0),
                child:Icon(Icons.close,size: 35,),
              ),
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(
              height: H * 0.01,
            ),
            Center(
              child: CustomElevatedButtonWidget(
                horizontalPadding: 15,
                verticalPadding: 4,
                borderRadius: 15,
                fontSize: 16,
                textColor: Colors.white,
                text: (buttonText),
                onPressed: onConfrim,
              ),
            ),
            SizedBox(
              height: H * 0.01,
            ),
            Center(
              child: CustomElevatedButtonWidget(
                horizontalPadding: 15,
                verticalPadding: 4,
                borderRadius: 15,
                fontSize: 16,
                textColor: Colors.white,
                text: (buttonText2),
                onPressed: onConfrim2,
              ),
            ),
            SizedBox(height: H * 0.03),
          ],
        ),
      );
    },
  );
}



class CustomElevatedButtonWidget extends StatelessWidget {
  const CustomElevatedButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.fontSize,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color ?? Colors.redAccent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0,
          vertical: verticalPadding ?? 20,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}
