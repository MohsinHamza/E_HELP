import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheNetworkWidget extends StatelessWidget {
  final String? imageUrl;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final double? width;
  final double? height;
  const CacheNetworkWidget(
      {Key? key,
      this.errorWidget,
      this.loadingWidget,
      required this.imageUrl,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      height: height,
      width: width,
      placeholder: (context, url) =>
          loadingWidget ?? Image.asset("assets/images/defaultphoto.png"),
      errorWidget: (context, url, error) => ClipOval(
          clipBehavior: Clip.antiAlias,
          child: errorWidget ??
              Image.asset(
                "assets/images/defaultphoto.png",
                height: height,
                width: width,
              )),
      fit: BoxFit.cover,
    );
  }
}
