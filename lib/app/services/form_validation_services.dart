import 'package:get/get.dart';

class FormValidationService {

  static String? checkEmpty(String? value) {
    if (value != null && value.isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.length < 5) {
      return 'Name must not be less than 5 characters';
    }

    return null;
  }

  static String? isNumber(String? s) {
    if (s == null) {
      return 'Please enter number';
    }
    s = s.replaceAll("-", "");
    return double.tryParse(s) != null ? null : 'Please enter number';
  }


  static String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (value != null && !regex.hasMatch(value.trim()))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String? validatePhoneNumber(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value == null || value.isEmpty)
      return null;
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
  static String? validateSSN(String? value) {
    String patttern = r'^[12][0-9]*$';
    RegExp regExp =  RegExp(patttern);
    if (value == null || value.isEmpty)
      return null;
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
//"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"

  static String? validatePassword2(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must not be less than 6 characters';
    }

    return null;
  }
  static String? validatePassword(String? value) {
    String missings = "";
    if (value!.length < 8) {
      missings += "Password has at least 8 characters\n";
    }

    if (!RegExp("(?=.*[A-Za-z])").hasMatch(value)) {
      missings += "Password must contain at least one letter\n";
    }
    if (!RegExp((r'\d')).hasMatch(value)) {
      missings += "Password must contain at least one digit\n";
    }
    if (!RegExp((r'\W')).hasMatch(value)) {
      missings += "Password must contain at least one symbol\n";
    }
    if (missings != "") {
      return missings;
    }

    //success
    return null;
  }

  static String? confirmPasswordValidation(
      String password, String confirmPassword) {
    if (password != confirmPassword) {
      return "Password doesn't match";
    }

    return null;
  }

  static String? validateEndDate(
      String value, DateTime? endDate, String frequency, bool isRecurring) {
    print('endDate: ' + endDate.toString());
    if (endDate == null || value.length == 0) {
      return "Please select a date";
    } else if (frequency == 'Weekly' && !isRecurring) {
      //next week date
      DateTime now = DateTime.now();
      DateTime nextWeekDate = DateTime(now.year, now.month, now.day + 7);
      print('nextWeekDate: ' + nextWeekDate.toString());
      if (endDate.isBefore(nextWeekDate)) return "Can't select this date";
    } else if (frequency == 'Bi-Weekly' && !isRecurring) {
      //next week date
      DateTime now = DateTime.now();
      DateTime nextBiWeekDate = DateTime(now.year, now.month, now.day + 14);
      print('nextBi-WeeklyDate: ' + nextBiWeekDate.toString());
      if (endDate.isBefore(nextBiWeekDate)) return "Can't select this date";
    } else if (frequency == 'Monthly' && !isRecurring) {
      //next week date
      DateTime now = DateTime.now();
      DateTime nextMonthDate = DateTime(now.year, now.month, now.day + 30);
      print('nextMonthlyDate: ' + nextMonthDate.toString());
      if (endDate.isBefore(nextMonthDate)) return "Can't select this date";
    }
    return null;
  }
}