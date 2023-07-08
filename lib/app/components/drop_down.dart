import 'package:flutter/material.dart';
import 'package:getx_skeleton/app/data/local/country_model.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';

class CustomDropDownPopup extends StatelessWidget {
  final List<LocalCountryModel> dropDownList;
  final IconData iconData;
  final Color iconColor;
  final void Function(LocalCountryModel) onSelected;
  final bool isIconCenter;

  const CustomDropDownPopup({
    required this.dropDownList,
    required this.onSelected,
    this.iconData = Icons.more_vert,
    this.isIconCenter = false,
    this.iconColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: PopupMenuButton<LocalCountryModel>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        itemBuilder: (context) => dropDownList
            .map((value) => PopupMenuItem(
                  value: value,
                  child: Text(
                    value.name,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ))
            .toList(),
        initialValue: null,
        onCanceled: () {
        },
        onSelected: onSelected,
        icon: Align(alignment: isIconCenter ? Alignment.topCenter : Alignment.center, child: Icon(iconData, size: 20, color: iconColor)),
      ),
    );
  }
}

class CustomDropDownPopup2 extends StatelessWidget {
  final List<String> dropDownList;
  final Widget iconData;
  final Color iconColor;
  final void Function(String) onSelected;
  final bool isIconCenter;

  const CustomDropDownPopup2({
    required this.dropDownList,
    required this.onSelected,
    required this.iconData,
    this.isIconCenter = false,
    this.iconColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (context) => dropDownList
          .map((value) => PopupMenuItem(
                value: value,
                child: Row(
                  children: [
                    const Icon(Icons.local_police, color: AppColors.lightRed, size: 20),
                    const SizedBox(width: 10),
                    Text(value, style: const TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ))
          .toList(),
      initialValue: null,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: onSelected,
      child: iconData,
    );
  }
}