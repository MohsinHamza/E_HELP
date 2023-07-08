import 'package:flutter/material.dart';

class calendarTest extends StatefulWidget {
  const calendarTest({Key? key}) : super(key: key);

  @override
  State<calendarTest> createState() => _calendarTestState();
}

class _calendarTestState extends State<calendarTest> {
  @override
  Widget build(BuildContext context) {
    return DateRangePickerDialog(
      // isMonth: true,
      // startDate: (_,){},
      // endDate: (_,){},
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 5))),
      firstDate: DateTime.now(),
      // the earliest allowable
      lastDate:DateTime.now().add(const Duration(days: 364)),
      // the latest allowable
      currentDate: DateTime.now(),
    );

  }
}