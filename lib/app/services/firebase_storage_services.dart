import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/utils/functions.dart';
import 'package:image_picker/image_picker.dart';

abstract class StorageService {
  Future<String> uploadAFileToStorage(File file, Reference storageRef);
  Future<String> uploadVideoFileToStorage(XFile xfile, storageRef);
}

class FirebaseStorageService extends GetxService implements StorageService {
  @override
  Future<String> uploadAFileToStorage(File file, storageRef) async {
    File xfile = await Functions.compressFile(file.path);
    UploadTask uploadTask = storageRef.putFile(
        File(xfile.path), SettableMetadata(contentType: 'image/png'));
    //     UploadTask uploadTask = storageRef.putFile(
    //     File(file.path));


    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<String> uploadVideoFileToStorage(XFile xfile, storageRef) async {
    UploadTask uploadTask = storageRef.putFile(
        File(xfile.path), SettableMetadata(contentType: 'video/mp4'));
    //     UploadTask uploadTask = storageRef.putFile(
    //     File(file.path));

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
