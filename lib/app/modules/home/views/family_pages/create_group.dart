import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/models/group_model.dart';
import '../../../../../config/theme/apptextstyles.dart';
import '../../../../../config/theme/custom_app_colors.dart';
import '../../../../components/reuseable_button.dart';
import '../../../../controllers/groups_controller.dart';
import 'data/contacts_data.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupNameController = TextEditingController();

  bool _isLoading = false;
  GlobalGroupsController? con;
  @override
  void initState() {
    con = Get.find<GlobalGroupsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
        child: Reuseable_button(
          "DONE",
          AppColors.lightRed,
          SvgPicture.asset(""),
          () {
            if (_groupNameController.text.isEmpty ||
                _groupNameController.text == '') {
              Fluttertoast.showToast(msg: 'Group Name required');
              return;
            }
            setState(() {
              _isLoading = true;
            });
            con?.newGroup.name = _groupNameController.text.trimLeft();
            GroupModel model = con!.newGroup;
            con!.newGroup = GroupModel(members: []);
            con?.addNewGroup(model);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            });
          },
          isLoading: _isLoading,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: const BackButton(),
        elevation: 0.3,
        centerTitle: true,
        title: const Text(
          "Create Group",
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height - 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Enter Group Name",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 56,
                    child: TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        hintText: "Group Name",
                        hintStyle: AppTextStyles.kPrimaryS2W4,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: AppColors.S_text,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: AppColors.S_text,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                        "Allowed Capacity: ${10 - (con!.newGroup.members!.length)}",
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

                      return MemberContainer(

                        onPress: () {
                          var contact = CustomContactModel.fromMap(e);
                          if (Get.find<GlobalGroupsController>()
                              .newGroup
                              .members!
                              .isEmpty) {
                            Get.find<GlobalGroupsController>()
                                .newGroup
                                .members!
                                .add(contact);
                          } else {
                            if (Get.find<GlobalGroupsController>()
                                .newGroup
                                .members!
                                .any((element) =>
                            element.name.toLowerCase() ==
                                contact.name.toLowerCase())) {
                              Get.find<GlobalGroupsController>()
                                  .newGroup
                                  .members!
                                  .removeWhere((element) =>
                              element.name.toLowerCase() ==
                                  contact.name.toLowerCase());
                            } else {
                              Get.find<GlobalGroupsController>()
                                  .newGroup
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
        ],
      ),
    );
  }
}

class MemberContainer extends StatefulWidget {
  final Map<String, dynamic> contactModel;
  final Function onPress;
  final bool isAdded;

  const MemberContainer({
    Key? key,
    required this.onPress,
    required this.contactModel,
    this.isAdded = false,
  }) : super(key: key);

  @override
  State<MemberContainer> createState() => _MemberContainerState();
}

class _MemberContainerState extends State<MemberContainer> {
  bool isAdded = false;
  @override
  void initState() {
    isAdded = widget.isAdded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                  border: Border.all(
                    width: 0.5,
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      widget.contactModel['image'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contactModel['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '+1 341-999-9078',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  widget.onPress();

                  setState(() {
                    isAdded = !isAdded;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAdded ? Colors.greenAccent : Colors.redAccent,
                    border: Border.all(
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isAdded ? Icons.done : Icons.add,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
