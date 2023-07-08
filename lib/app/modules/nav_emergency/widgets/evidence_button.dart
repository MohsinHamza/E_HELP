import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvidenceButtonWithIcon extends StatefulWidget {
  String title;
  String iCon;
  bool isSelected;
  VoidCallback ontap;
  EvidenceButtonWithIcon(
      {Key? key,
      required this.title,
      required this.iCon,
      required this.isSelected,
      required this.ontap})
      : super(key: key);

  @override
  State<EvidenceButtonWithIcon> createState() => _EvidenceButtonWithIconState();
}

class _EvidenceButtonWithIconState extends State<EvidenceButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * .075,
        margin: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.grey[500] : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment:widget.iCon==''? MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.iCon==''?false:true,
                child: Image(
                  image: AssetImage(widget.iCon),
                  color: Colors.red,
                  height: widget.iCon=='assets/icons/injury.png'?28:20,
                  width: widget.iCon=='assets/icons/injury.png'?28:20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                    color: widget.isSelected ? Colors.black : Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
