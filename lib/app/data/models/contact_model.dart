import 'package:cloud_firestore/cloud_firestore.dart';

///Can be use for both Contacts and Paid Contacts just play with params...
class ContactModel {
  String? docId;
  String? name;
  String? phoneNumber;
  String? address;
  String? relation;
  String? picture;
  bool? isPaid;
  DocumentReference? reference;

  //TODO: remove default contructor... after connecting with db....
  ContactModel() ;

  Map<String, dynamic> toJson() => {
        'name': name,
        "phoneNumber": phoneNumber,
        "address": address,
        "relation": relation,
        "picture": picture,
        "docId": docId,
        "isPaid": isPaid,

      };

  ContactModel.fromMap(map, {this.reference})
      : name = map['name'],
        phoneNumber = map['phoneNumber'],
        address = map['address'],
        relation = map['relation'],
        docId = reference?.id??map['docId'],
        isPaid = map['isPaid'],
        picture = map['picture'];



  ContactModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
