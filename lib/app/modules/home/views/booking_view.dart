import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../choose_plans/calendat_booking_view.dart';

class BookingScreen extends GetView {
  final bool? isFromExpired;
  final bool isMonthlySelected;

  const BookingScreen(
      {Key? key, this.isFromExpired, this.isMonthlySelected = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("IS FROM EXPIRED $isFromExpired");
    print("IS MONHTLY LOCATION  $isMonthlySelected");
    return Scaffold(
      body: CalendarPaymentBuyPage(
        isFromExpired: isFromExpired ?? false,
        isYearSelectedTab: !isMonthlySelected,
      ),
    );
  }
}
