import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CameraImagePickerView extends StatelessWidget {
  final VoidCallback pickFromCamera;
  final VoidCallback pickFromGallery;
  const CameraImagePickerView(
      {required this.pickFromCamera, required this.pickFromGallery, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // heightFactor: 0.20.h, //overflow by badar from 0.17
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title:const Text("Camera"),
            onTap: pickFromCamera,
          ),

          ListTile(
            leading:const Icon(Icons.image),
            title: const Text("Gallery"),
            onTap: pickFromGallery,
          ),

        ],
      ),
    );
  }
}