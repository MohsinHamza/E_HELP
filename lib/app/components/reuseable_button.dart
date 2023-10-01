import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/apptextstyles.dart';

class Reuseable_button extends StatelessWidget {
  Reuseable_button(this.txt, this.clr, this.picture, this.onPress,
      {this.shouldHavePadding = true, this.isLoading});

  final String txt;
  final Color clr;
  final SvgPicture? picture;
  final bool shouldHavePadding;
  final void Function()? onPress;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(clr),
        ),
        onPressed: onPress,
        child: Padding(
          padding: shouldHavePadding
              ? const EdgeInsets.symmetric(vertical: 10)
              : EdgeInsets.zero,
          child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    picture ?? Container(),
                    const SizedBox(
                      width: 10,
                    ),
                    isLoading != null && isLoading == false?Text(
                      txt,
                      style: AppTextStyles.kPrimaryS3W4,
                    ):const CircularProgressIndicator(color: Colors.white,),
                  ],
                ),
        ),
      ),
    );
  }
}
