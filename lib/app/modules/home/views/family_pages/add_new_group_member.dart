import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/controllers/groups_controller.dart';
import '../../../../data/models/group_model.dart';
import 'create_group.dart';
import 'data/contacts_data.dart';

class AddGroupMember extends StatefulWidget {
  const AddGroupMember({Key? key}) : super(key: key);

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  GlobalGroupsController? con;
  @override
  void initState() {
    con = Get.find<GlobalGroupsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Group Member'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              15.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Contacts",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Allowed Capacity: ${10 - (con!.selectedGroup.members!.length)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                ...Data().contacts.map(
                  (e) {
                    bool isAdded = false;
                    var b = CustomContactModel.fromMap(e);
                    String name = b.name.toLowerCase();
                    if (con!.selectedGroup.members!
                        .any((element) => element.name.toLowerCase() == name)) {
                      isAdded = true;
                    }
                    return MemberContainer(
                      isAdded: isAdded,
                      onPress: () {
                        var contact = CustomContactModel.fromMap(e);
                        if (Get.find<GlobalGroupsController>()
                            .selectedGroup
                            .members!
                            .isEmpty) {
                          Get.find<GlobalGroupsController>()
                              .selectedGroup
                              .members!
                              .add(contact);
                        } else {
                          if (Get.find<GlobalGroupsController>()
                              .selectedGroup
                              .members!
                              .any((element) =>
                                  element.name.toLowerCase() ==
                                  contact.name.toLowerCase())) {
                            Get.find<GlobalGroupsController>()
                                .selectedGroup
                                .members!
                                .removeWhere((element) =>
                                    element.name.toLowerCase() ==
                                    contact.name.toLowerCase());
                          } else {
                            Get.find<GlobalGroupsController>()
                                .selectedGroup
                                .members!
                                .add(contact);
                          }
                        }
                        setState(() {});
                      },
                      contactModel: e,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
