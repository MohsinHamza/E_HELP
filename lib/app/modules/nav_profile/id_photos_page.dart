import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/app/modules/auth/pick_photos_screen.dart';

class IDPhotosPage extends StatefulWidget {
  const IDPhotosPage({Key? key}) : super(key: key);

  @override
  State<IDPhotosPage> createState() => _IDPhotosPageState();
}

class _IDPhotosPageState extends State<IDPhotosPage> {
  String? back;
  String? front;
  bool isNotFound=false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await getIdImages());
  }

  getIdImages() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    // 'uid':myAppUser.id,
    // 'idBackside':back,
    // 'idFrontSide':front,
    var snap = await FirebaseFirestore.instance
        .collection('userIdImages')
        .where('uid', isEqualTo: id)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      var data = snap.docs.first.data();
      back = data['idBackside'];
      front = data['idFrontSide'];
      setState(() {});
    }else{
      isNotFound = true;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
        ),
       centerTitle: true,
       title: const Text('ID Proof'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IdPhotoPickingContainer(
                  isNotFound: isNotFound,
                  imageUrl: front,
                  isLoading: front == null ? true : false,
                  title: 'Front Side',
                  height: 200,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                IdPhotoPickingContainer(
                  isNotFound: isNotFound,
                  imageUrl: back,
                  isLoading: back == null ? true : false,
                  height: 200,
                  title: 'Back Side',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
