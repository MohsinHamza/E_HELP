import 'package:getx_skeleton/utils/DateFormate_utils.dart';

///Uses to translate data from link to model
class DynamicLinkPayloadModel {
  final String phoneNumber;
  final String guardianName;
  final String guardianUid;
  final int durationStart;
  final int durationEnd;

  DynamicLinkPayloadModel(
      {required this.phoneNumber,
      required this.guardianName,
      required this.guardianUid,
      required this.durationStart,
      required this.durationEnd});

  @override

  ///returns queryparams for object
  String toString() {
    return "?phoneNumber=$phoneNumber&guardianName=$guardianName&guardianUid=$guardianUid&durationStart=$durationStart"
        "&durationEnd=$durationEnd";
  }

  String invitedByString() {
    return "You've been invited by $guardianName and paid for you from ${CustomeDateFormate.DOB(durationStart)} to "
        "${CustomeDateFormate.DOB(durationEnd)}";
  }

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        "guardianName": guardianName,
        "guardianUid": guardianUid,
        "durationStart": durationStart,
        "durationEnd": durationEnd
      };

  DynamicLinkPayloadModel.fromMap(map)
      : phoneNumber = map['phoneNumber'],
        guardianName = map['guardianName'],
        guardianUid = map['guardianUid'],
        durationStart = int.parse( map['durationStart'].toString()),
        durationEnd = int.parse(map['durationEnd'].toString());
}