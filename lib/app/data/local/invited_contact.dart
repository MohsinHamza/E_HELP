class InvitedContactModel {
  final String invitedBy;
  final String expiryMillis;
   String type;

  InvitedContactModel({required this.invitedBy, required this.expiryMillis, this.type = "Invited"});

  toJson() => {'invitedBy': invitedBy, "expiryMillis": expiryMillis,"type":type};

  InvitedContactModel.fromMap(map)
      : invitedBy = map['invitedBy'],
        type = map['type']??'',
        expiryMillis = map['expiryMillis'];

  ///returns queryparams for object
  @override
  String toString() {
    return "?invitedBy=$invitedBy&expiryMillis=$expiryMillis&type=$type";
  }
}