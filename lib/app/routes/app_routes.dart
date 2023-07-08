part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  static const HOW_TO_USE_APP=_Paths.HOW_TO_USE_APP;

  Routes._();

  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const EMERGENCYTYPE = _Paths.EMERGENCYTYPE;
  static const RECORDEVIDENCE = _Paths.RECORDEVIDENCE;
  static const MYEVIDENCES = _Paths.MYEVIDENCES;
  static const BOOKINGS = _Paths.BOOKINGS;
  static const INVITE = _Paths.INVITE;
  static const FEEDBACK = _Paths.FEEDBACK;
  static const SEEYOURID = _Paths.SEEYOURID;

  static const SPLASH = _Paths.SPLASH;
  ///[/home]
  static const HOME = _Paths.HOME;

  ///[/locate]
  static const LOCATE = _Paths.LOCATE;

  ///[/contacts]
  static const CONTACTS = _Paths.CONTACTS;

  ///[/emergency]
  static const EMERGENCY = _Paths.EMERGENCY;
  static const PLANS = _Paths.PLANS;

  ///[/users]
  static const USERS = _Paths.USERS;

  ///[/profile]
  static const PROFILE = _Paths.PROFILE;

  ////[addemergencycontact]
  static const ADD_EMERGENCY_CONTACT = _Paths.ADD_EMERGENCY_CONTACT;

  ////[addemergencycontact]
  static const PAY_FOR_FAMILY_FRIEND = _Paths.PAY_FOR_FAMILY_FRIEND;

  ///PASS ARGUMENT
  static getRouteAddEmergencyContact({ContactModel? model}) {
    print("***routing..");
    if (model == null) {
      return '$ADD_EMERGENCY_CONTACT?data=null';
    }
    String _data = encodeArgument(model);
    return '$ADD_EMERGENCY_CONTACT?data=$_data';
  }
  static getRouteSignup({DynamicLinkPayloadModel? model, InvitedContactModel? invitedContactModel}) {
    if (model == null && invitedContactModel == null) {
      return '$SIGNUP?data=null';
    }
    String _data = encodeArgument(model ?? invitedContactModel);
    return '$SIGNUP?data=$_data';
  }
}

abstract class _Paths {
  static const HOW_TO_USE_APP='/demo_video';

  static const PLANS='/plans';

  _Paths._();

  static const HOME = '/home';

  //auth Paths
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const EMERGENCYTYPE = '/EmergencyType';
  static const RECORDEVIDENCE = '/RecordEvidence';
  static const MYEVIDENCES = '/MYEVIDENCES';
  static const FEEDBACK = '/feedback';
  static const SEEYOURID = '/SEEYOURID';

  static const SPLASH = "/splash";
  static const BOOKINGS = "/BOOKINGS";
  static const INVITE = "/INVITE";
  //normal paths...
  ////addemergencycontact
  static const ADD_EMERGENCY_CONTACT = '/addemergencycontact';
  static const PAY_FOR_FAMILY_FRIEND = '/payforfamilyfriend';

  //navbar paths...
  static const LOCATE = '/locate';
  static const CONTACTS = '/contacts';
  static const EMERGENCY = '/emergency';
  static const USERS = '/users';
  static const PROFILE = '/profile';
}