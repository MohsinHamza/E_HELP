import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/nav_emergency/controllers/transaction_alert_controller.dart';
import 'package:getx_skeleton/app/modules/nav_emergency/widgets/evidence_button.dart';
import 'package:google_fonts/google_fonts.dart';

enum EmergencyTypes {
  vehicleIssue,
  crime,
  sicknessOrInjury,
  lostOrTrapped,
  fire,
}

enum whoNeedsHelp { me, someOneElse, multiplePeople }

class EvidencePermissionController extends GetxController {
  int index = 0;
  String emergencyTypes = EmergencyTypes.vehicleIssue.name;
  String needsHelp = whoNeedsHelp.me.name;
  RxList<Widget> pages = [
    const EmergencyType(),
    const WhoNeedsHelp(),
  ].obs;
  void checkBoxChange(int index) {
    this.index = index;
    update();
  }
}

class EvidencePermissionControllerBinding extends Bindings {
  @override
  void dependencies() {
    debugPrint("EvidencePermissionController");
    Get.lazyPut<EvidencePermissionController>(
      () => EvidencePermissionController(),
    );
  }
}

class EmergencyPermission extends GetView<EvidencePermissionController> {
  EmergencyPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'Skip',
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/icons/men_logo.png'),
                    height: 150,
                    width: 150,
                  ),
                ),
                GetBuilder<EvidencePermissionController>(builder: (con) {
                  return con.pages[con.index];
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyType extends StatefulWidget {
  const EmergencyType({Key? key}) : super(key: key);

  @override
  State<EmergencyType> createState() => _EmergencyTypeState();
}

class _EmergencyTypeState extends State<EmergencyType> {
  final detailsController = TextEditingController();
  final List<EvidenceButtonObj> _emergencyType = [
    EvidenceButtonObj(
      imageName: 'assets/icons/car.png',
      title: 'Car or Vehicle issue',
      emergencyTypes: EmergencyTypes.vehicleIssue.name,
    ),
    EvidenceButtonObj(
        emergencyTypes: EmergencyTypes.sicknessOrInjury.name,
        imageName: 'assets/icons/injury.png',
        title: 'Sickness or injury'),
    EvidenceButtonObj(
      imageName: 'assets/icons/crime.png',
      title: 'Crime or Violence',
      emergencyTypes: EmergencyTypes.crime.name,
    ),
    EvidenceButtonObj(
      imageName: 'assets/icons/lost.png',
      title: 'Lost or Trapped',
      emergencyTypes: EmergencyTypes.lostOrTrapped.name,
    ),
    EvidenceButtonObj(
      imageName: 'assets/icons/edit.png',
      title: 'Explain Details',
      emergencyTypes: EmergencyTypes.fire.name,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height * 1;

    return Column(
      children: [
        Text(
          "What's the Emergency?",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: screenHeight * .035,
        ),
        ...List.generate(_emergencyType.length, (index) {
          EvidenceButtonObj item = _emergencyType[index];
          return EvidenceButtonWithIcon(
            title: item.title,
            iCon: item.imageName,
            ontap: () async {
              for (int i = 0; i < _emergencyType.length; i++) {
                if (i != index) {
                  _emergencyType[i].isSelected = false;
                }
              }
              _emergencyType[index].isSelected = true;
              if (index != 4) {
                Get.find<EvidencePermissionController>().emergencyTypes =
                    _emergencyType[index].emergencyTypes!;
              } else {
                await typeEmergencyDetails();
                Get.find<EvidencePermissionController>().emergencyTypes =
                    detailsController.text.trim();
              }

              setState(() {});
            },
            isSelected: item.isSelected,
          );
        }),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Get.find<EvidencePermissionController>().checkBoxChange(1);
          },
          child: Container(
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 28),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  typeEmergencyDetails() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          content: SizedBox(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: TextField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      hintText: "Explain Emergency Details",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 3.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        12.0,
                      ),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            detailsController.text = '';
                          },
                          child: const Text(
                            "CLOSE",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WhoNeedsHelp extends StatefulWidget {
  const WhoNeedsHelp({Key? key}) : super(key: key);

  @override
  State<WhoNeedsHelp> createState() => _WhoNeedsHelpState();
}

class _WhoNeedsHelpState extends State<WhoNeedsHelp> {
  final List<EvidenceButtonObj> _emergencyType = [
    EvidenceButtonObj(
        imageName: '', title: 'Me', needsHelp: whoNeedsHelp.me.name),
    EvidenceButtonObj(
        imageName: '',
        title: 'Someone Else',
        needsHelp: whoNeedsHelp.someOneElse.name),
    EvidenceButtonObj(
        imageName: '',
        title: 'Multiple People',
        needsHelp: whoNeedsHelp.multiplePeople.name),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height * 1;
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Text(
          "Who needs help?",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: screenHeight * .065,
        ),
        ...List.generate(_emergencyType.length, (index) {
          EvidenceButtonObj item = _emergencyType[index];
          return EvidenceButtonWithIcon(
            title: item.title,
            iCon: item.imageName,
            ontap: () {
              for (int i = 0; i < _emergencyType.length; i++) {
                if (i != index) {
                  _emergencyType[i].isSelected = false;
                }
              }
              _emergencyType[index].isSelected = true;
              Get.find<EvidencePermissionController>().needsHelp =
                  _emergencyType[index].needsHelp!;
              setState(() {});
            },
            isSelected: item.isSelected,
          );
        }),

        InkWell(
          onTap: () {
            Get.find<TransactionAlertController>().emergencyType.value =
                Get.find<EvidencePermissionController>().emergencyTypes;
            Get.find<TransactionAlertController>().whoNeedsHelp.value =
                Get.find<EvidencePermissionController>().needsHelp;
            Get.find<TransactionAlertController>().update();
            Get.back();
          },
          child: Container(
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 28,vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EvidenceButtonObj {
  String title;
  String imageName;
  bool isSelected;
  String? emergencyTypes;
  String? needsHelp;
  EvidenceButtonObj(
      {required this.imageName,
      this.needsHelp,
      this.emergencyTypes,
      required this.title,
      this.isSelected = false});
}
