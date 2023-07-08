import 'package:flutter/material.dart';
import 'package:getx_skeleton/app/components/CacheNetworkWidget.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';

class CircularImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;

  const CircularImageWidget({Key? key, required this.imageUrl, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 120.0,
      height:height?? 120.0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
       // borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: AppColors.Kblue_type,
      ),
      child: CacheNetworkWidget(
        imageUrl: imageUrl,
      ),
    );
  }
}