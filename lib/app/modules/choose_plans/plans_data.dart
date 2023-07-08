import 'package:get/get.dart';

class PackagePriceModel extends GetxService {
  static PackagePriceModel get find => Get.find();
  String title;
  String description;
  String duration;
  String price;
  bool isSelected;
  PackagePriceModel({
    required this.price,
    required this.description,
    required this.title,
    required this.duration,
    required this.isSelected,
  });
  update(PackagePriceModel user) {
    title = user.title;
    description = user.description;
    duration = user.duration;
    price = user.price;
    isSelected = user.isSelected;
  }

  toMap() {
    return {
      'title': title,
      "description": description,
      "price": price,
      "duration": duration,
      "isSelected": isSelected,
    };
  }
}

List<String> soloMonthlyFeatures = [
  "Total access across United States or one selected country",
  "SMS alert message to emergency contact list",
  "Cross platform access available on both Android & IOS",
  "Store video & picture evidence",
];
List<String> soloYearlyFeatures = [
  "Total access across United States or one selected country",
  "SMS alert message to emergency contact list",
  "Cross platform access available on both Android & IOS",
  "Store video & picture evidence",
  "International Access to All M.E.N Serving countries",
  "365 days of full service access",
];


// class SubscriptionPackages {
//   static List<PackagePriceModel> packages = [
//     PackagePriceModel(
//       price: '\$15',
//       isSelected: true,
//       description:
//           "Access to service in ONE country for .50¢ a day. Ideal for anyone traveling short term. Subscription lasts for 30 days from chosen start date.",
//       title: "Solo Standard Plan",
//       duration: '/mo',
//     ),
//     PackagePriceModel(
//       isSelected: false,
//       price: '\$120',
//       description:
//           "Access to ALL M.E.N servicing countries for less than .33¢ per day. Subscription lasts for 365 days from chosen start date.",
//       title: "Solo Premium Plan",
//       duration: '/yr',
//     ),
//     PackagePriceModel(
//       isSelected: false,
//       price: '\$30',
//       description:
//           "\$10 per person, 3-6 peoples. Access to services in ONE country of choice. In this your subscription lasts for 30 days from start date.",
//       title: "Standard family plan",
//       duration: '/mo',
//     ),
//     PackagePriceModel(
//       isSelected: false,
//       price: '\$300',
//       description:
//           "\$100 per person, 3-6 people. Access to ALL M.E.N servicing countries. Subscription lasts for 365 days from chosen start date.",
//       title: "Premium family plan",
//       duration: '/yr',
//     ),
//   ];
// }
