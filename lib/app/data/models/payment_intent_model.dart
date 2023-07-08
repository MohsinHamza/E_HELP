import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentIntentModel {
  String? paymentIntentClientSecret;
  String? customerId;
  String? customerEphemeralKeySecret;
  DocumentReference? reference;

  PaymentIntentModel({this.paymentIntentClientSecret, this.customerId, this.customerEphemeralKeySecret});

  toJson() => {
    "paymentIntentClientSecret": paymentIntentClientSecret,
    "customerId": customerId,
    "customerEphemeralKeySecret": customerEphemeralKeySecret,
  };

  PaymentIntentModel.fromMap(map, {this.reference})
      : paymentIntentClientSecret = map['paymentIntentClientSecret'],
        customerId = map['customerId'],
        customerEphemeralKeySecret = map['customerEphemeralKeySecret'];

  PaymentIntentModel.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}