import 'package:flutter/material.dart';

import '../../../../config/theme/apptextstyles.dart';
import '../../../../config/theme/custom_app_colors.dart';
import '../../../../config/theme/dimensions.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final  onPress;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(
              color: AppColors.Proyel_blue,
              fontSize: AppDimensions.kMediumSize),
        ),
        InkWell(
          onTap: onPress,
          child: Text(
            login ? " Sign Up" : " Sign In",
            style: AppTextStyles.kPrimaryS4W4,
          ),
        )
      ],
    );
  }
}
