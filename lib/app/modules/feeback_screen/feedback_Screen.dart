import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/utils/functions.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../../../config/theme/custom_app_colors.dart';
import '../../components/textfield.dart';
import '../../services/FirebaseFirestoreServices.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  double ratingvalue = 0;
  final reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  final MyAppUser userdata = MyAppUser.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: const Text('Give Feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              const Text("How did we do?", style: TextStyle(fontSize: 15)),
              const SizedBox(height: 10.0),
              SimpleStarRating(
                  allowHalfRating: false,
                  isReadOnly: false,
                  starCount: 5,
                  rating: ratingvalue,
                  size: 30,
                  onRated: (rate) => ratingvalue = rate!,
                  spacing: 10),
              const SizedBox(height: 37.0),
              DotWidget(
                  dashHeight: 1,
                  emptyWidth: 2,
                  dashColor: Colors.grey,
                  totalWidth: MediaQuery.of(context).size.width - 48,
                  dashWidth: 3),
              // Divider(),
              const SizedBox(height: 37.0),
              //
              const Text("Care to share more about it?", style: const TextStyle(fontSize: 15)),
              //textbox
              const SizedBox(height: 24),
              PrimaryTextField(
                  hintStyle: const TextStyle(fontSize: 15),
                  borderColor: Colors.grey,
                  controller: reviewController,
                  hintText: '',
                  maxLines: 10),

              //dotted divider
              const SizedBox(height: 37.0),
              DotWidget(
                  dashHeight: 1,
                  emptyWidth: 2,
                  dashColor: const Color(0xffB0E4BC),
                  totalWidth: MediaQuery.of(context).size.width - 48,
                  dashWidth: 3),
              const SizedBox(height: 37.0),

              //publish button
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.Kblue_type)),
                onPressed: () {
                  //submit feedback
                  FeedbackModel feedback =
                      FeedbackModel(value: ratingvalue, userreview: reviewController.text, submittedby: userdata.id ?? "");
                  FirestoreService firestoreService = FirebaseFirestoreService();
                  firestoreService.submitFeedback(feedback);
                  //show dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ThanksForReviewDialogBox();
                    },
                  ).then((value) => Navigator.pop(context));
                },
                child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Text("PUBLISH FEEDBACK", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
              ),

              TextButton(
                  style:
                      const ButtonStyle(visualDensity: VisualDensity(vertical: -2), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () => Functions.openEmailAppSupport(),
                  child: const Text("or Contact us via E-mail", style: TextStyle(fontSize: 12, color: Colors.grey))),
              const SizedBox(height: 16.0),
              const Text("Your review will be sent to E.Help Team", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}

class DotWidget extends StatelessWidget {
  final double totalWidth, dashWidth, emptyWidth, dashHeight;

  final Color dashColor;

  const DotWidget({
    this.totalWidth = 300,
    this.dashWidth = 10,
    this.emptyWidth = 5,
    this.dashHeight = 2,
    this.dashColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalWidth ~/ (dashWidth + emptyWidth),
        (_) => Container(
          width: dashWidth,
          height: dashHeight,
          color: dashColor,
          margin: EdgeInsets.only(left: emptyWidth / 2, right: emptyWidth / 2),
        ),
      ),
    );
  }
}

class FeedbackModel {
  String? uid;
  double value;
  String userreview;
  String submittedby;

  FeedbackModel({
    required this.value,
    required this.userreview,
    required this.submittedby,
  });

  Map<String, dynamic> toMap() {
    return {'value': value, 'userreview': userreview, 'submittedby': submittedby};
  }

  FeedbackModel.fromMap(map, {this.uid})
      : value = map['value'],
        userreview = map['userreview'],
        submittedby = map['submittedby'];

  FeedbackModel.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), uid: snapshot.reference.id);
}

class ThanksForReviewDialogBox extends StatefulWidget {
  const ThanksForReviewDialogBox({Key? key}) : super(key: key);

  @override
  _ThanksForReviewDialogBoxState createState() => _ThanksForReviewDialogBoxState();
}

class _ThanksForReviewDialogBoxState extends State<ThanksForReviewDialogBox> {
  Widget build(BuildContext context) {
    return Dialog(
      // insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: SizedBox(
          height: 260,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              implus_circleAvatarWidget(child: const Center(child: const Icon(Icons.check, color: Colors.white, size: 35))),
              const SizedBox(height: 20.0),
              Text(
                'Thank you!',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Your feedback has been recieved to us.",
                textAlign: TextAlign.center,
                style:  TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

class implus_circleAvatarWidget extends StatelessWidget {
  final Widget child;

  implus_circleAvatarWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.green.withOpacity(.1),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.green.withOpacity(.2),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green.withOpacity(.3),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green.withOpacity(.4),
            child: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(.5),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}