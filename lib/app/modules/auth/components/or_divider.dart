import 'package:flutter/material.dart';

import '../../../../config/theme/apptextstyles.dart';


class Or_divider extends StatelessWidget {
  const Or_divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return        const Padding(
      padding: EdgeInsets.symmetric(vertical: 26.0),
      child: Text(
        "Or continue with",
        style: AppTextStyles.kPrimaryS2W4,
      ),
    );
  }
}
