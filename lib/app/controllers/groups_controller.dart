import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/home/views/family_pages/data/groups.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/models/group_model.dart';

class GlobalGroupsController extends GetxController implements GetxService {
  List<GroupModel> groups = [];
  int groupIndex = 0;
  GroupModel newGroup = GroupModel(members: []);

  GroupModel _selectedGroup = GroupModel(members: []);
  GroupModel get selectedGroup => _selectedGroup;
  set selectedGroup(v) {
    _selectedGroup = v;
    update();
  }

  @override
  void onInit() {
    groups = GroupsData().groups;
    selectedGroup = groups.first;
    var me = CustomContactModel.fromMap(
      {
        "name": "Me",
        "position": const LatLng(37.42796133580664, -122.085749655962),
        "marker": 'assets/markers/marker-1.png',
        "image": 'assets/images/avatar-1.png',
      },
    );
    selectedGroup.members!.add(me);
    newGroup.members!.add(me);
    super.onInit();
  }

  addNewGroup(GroupModel v) {
    groups.add(v);
    update();
  }

  setGroupIndex(int v) {
    groupIndex = v;
    update();
  }
}
