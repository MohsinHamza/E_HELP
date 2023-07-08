import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class CustomeDateFormate {
  static String DDMMMMDDDD(DateTime? date) {
    if (date == null) return "";
    return Jiffy(date, "dd, MMM E").MMMd + ", " + Jiffy(date, "dd, MMM E").EEEE;
  }

  static String DOB(int? milliseconds) {
    if (milliseconds == null) return "";
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateFormat('dd-MM-yyyy').format(dt);
  }

  static bool isSixHoursAgo(int? milliseconds) {
    if (milliseconds == null) return false;
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return Jiffy(dt).isSame(Jiffy(), Units.HOUR);
  }
  static DateTime MillisecondsToDOB(String? dob) {
    if (dob == null) return  DateTime(2020);
    DateFormat('MM-dd-yyyy').parse(dob);
    //var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateFormat('MM-dd-yyyy').parse(dob);;
  }
}