// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../../config/theme/apptextstyles.dart';
//
// class SeeAllFollowers extends StatefulWidget {
//   const SeeAllFollowers({Key? key}) : super(key: key);
//
//   @override
//   State<SeeAllFollowers> createState() => _SeeAllFollowersState();
// }
//
// class _SeeAllFollowersState extends State<SeeAllFollowers> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(),
//         centerTitle: true,
//         title: const Text('SignedUp on Invitation'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(FirebaseAuth.instance.currentUser!.uid)
//               .collection("signedOnMyInvitation")
//               .where('type', isEqualTo: 'redeemedBy')
//               .snapshots(),
//           builder: (_,
//               AsyncSnapshot<QuerySnapshot> snapshots) {
//             if(snapshots.connectionState == ConnectionState.waiting){
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             else if (snapshots.hasData) {
//               bool isEmpty = snapshots.data!.docs.isEmpty;
//               if(isEmpty){
//
//               }else{
//                 return const Center(
//                   child: Text(
//                     "Something wen\'t wrong",
//                     style: AppTextStyles.kPrimaryS8W3,
//                   ),
//                 );
//               }
//             } else{
//               return const Center(
//                 child: Text(
//                   "Something wen\'t wrong",
//                   style: AppTextStyles.kPrimaryS8W3,
//                 ),
//               );
//             }
//
//           },
//         ),
//       ),
//     );
//   }
// }
