import 'package:flutter/material.dart';

class Visibility_icon extends StatelessWidget {
  const Visibility_icon({
    Key? key,
    required this.press,
  }) : super(key: key);
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.visibility,
        color: Colors.grey,
        size: 20,
      ),
      onPressed: press as void Function()?,
    );
  }
}
