import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../config/translations/strings_enum.dart';






/// this method will show black overlay which look like dialog
/// and it will have loading animation inside of it
/// this will make sure user cant interact with ui until
/// any (async) method is excuting cuz it will wait for asyn function
/// to end and then it will dismiss the overlay
showLoadingOverLay({required Future<dynamic> Function() asyncFunction,String? msg,}) async
{
  await Get.showOverlay(asyncFunction: () async {
    try{
      await asyncFunction();
    }catch(error){
      Logger().e(error);
      Logger().e(StackTrace.current);
    }
  },loadingWidget: Center(
    child: getLoadingIndicator(msg: msg),
  ),opacity: 0.7,
    opacityColor: Colors.black,
  );
}

getCircularIndicator(BuildContext context){
  return  showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Card(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 45,
              width: 45,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      });
}

Widget getLoadingIndicator({String? msg}){
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 20.w,
      vertical: 10.h,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: Colors.white,
    ),
    child: Column(mainAxisSize: MainAxisSize.min,children: [
      Image.asset('assets/images/img.png',height: 45.h,),
      SizedBox(width: 8.h,),
      Text(msg ?? Strings.loading,style: Get.theme.textTheme.bodyText1),
    ],),
  );
}





class PreloaderCircular extends StatelessWidget {
  final double size;

  final Color preloaderColor;
  final Color bgColor;

  const PreloaderCircular({

    this.size = 64,

    this.bgColor = Colors.white,
    this.preloaderColor = Colors.red,

  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width:   64,
        height:  64,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        padding:const EdgeInsets.all(20),
        child: Theme(
          data: ThemeData(colorScheme: Theme.of(context).colorScheme.copyWith(
            secondary: Colors.red,
          ),),
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            // color: Get.theme.primaryColor,
            backgroundColor: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }
}