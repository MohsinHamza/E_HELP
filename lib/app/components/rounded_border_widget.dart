import 'package:flutter/material.dart';

class RoundedBorderWidget extends StatelessWidget {
  final double borderRadius;
  final Widget child;

  const RoundedBorderWidget({Key? key, required this.child, this.borderRadius = 8.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: child);
  }
}