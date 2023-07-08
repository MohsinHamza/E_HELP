import 'package:flutter/material.dart';

import '../../../../config/theme/apptextstyles.dart';

class ListTile_Profile extends StatelessWidget {
  ListTile_Profile(this.txt, this.subtxt, {Key? key,this.isVisible = true}) : super(key: key);
  String txt;
  String subtxt;
  bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: ListTile(
              title: Text(txt, style: AppTextStyles.kPrimaryS9W3,),
              subtitle: Text(subtxt, style: AppTextStyles.kPrimaryS9W4,),
            ),

          ),
          SizedBox(height: 4,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(height: 2,),
          )
        ],
      ),
    );
  }
}