import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/models/group_model.dart';
import 'package:getx_skeleton/app/modules/home/views/family_pages/controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/groups_controller.dart';
import '../../../../routes/app_pages.dart';
import 'data/groups.dart';

class FamilyEmergencyGroupsPage extends StatefulWidget {
  const FamilyEmergencyGroupsPage({Key? key}) : super(key: key);

  @override
  _FamilyEmergencyGroupsPageState createState() =>
      _FamilyEmergencyGroupsPageState();
}

class _FamilyEmergencyGroupsPageState extends State<FamilyEmergencyGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Groups',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            NewGroupButton(
              onTapped: () {
                Get.toNamed(Routes.CREATEGROUP);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: SingleChildScrollView(
          child: GetBuilder<GlobalGroupsController>(
            builder: (con) {
              return Column(
                children: [
                  ...con.groups.map(
                    (e) => GroupContainer(
                      index: con.groups.indexOf(e),
                      model: e,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GroupContainer extends StatelessWidget {
  const GroupContainer({Key? key, required this.model, required this.index}) : super(key: key);
  final GroupModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var d= Get.find<GlobalGroupsController>();
        d.selectedGroup=model;
        d.groupIndex= index;
        Get.toNamed(
          Routes.EMERGENCY_FAMILY_GROUPS_MAP,
          id: 1,
        );
      },
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(
            12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.2,
              ),
              offset: const Offset(
                0,
                4,
              ),
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                            0.2,
                          ),
                          offset: const Offset(
                            0,
                            2.5,
                          ),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      ...model.members!.map(
                        (e) => model.members!.indexOf(e) >= 5
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                  left: model.members!.indexOf(e) == 0
                                      ? 0
                                      : 2.0 + (model.members!.indexOf(e) * 25),
                                ),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    border: Border.all(
                                      width: 0.5,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                          0.2,
                                        ),
                                        offset: const Offset(
                                          0,
                                          4,
                                        ),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Image.asset(
                                    e.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  Text(
                    'Members Capacity:  ${10 - model.members!.length}',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewGroupButton extends StatelessWidget {
  const NewGroupButton({
    Key? key,
    required this.onTapped,
  }) : super(key: key);
  final Function() onTapped;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapped();
      },
      child: Container(
        height: 30,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.white12,
                offset: Offset(2, 4),
                spreadRadius: 1,
                blurRadius: 1,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.red,
              size: 22,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'New Group',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
