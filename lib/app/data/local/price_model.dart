class PriceModel {
  late int price;
  late String priceName;

  PriceModel({required this.price, required this.priceName});

  PriceModel.fromMap(Map<String, dynamic> map, {String? id}) {
    price = map['price'];
    priceName = map['name'];
  }
}