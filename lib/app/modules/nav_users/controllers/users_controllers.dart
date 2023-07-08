import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';

import '../../../data/models/contact_model.dart';
import '../../../services/FirebaseFirestoreServices.dart';

class UsersController extends BaseController {
  static UsersController get to => Get.find();
  final FirebaseFirestoreService firebaseFirestoreServices = Get.find();
  List<ContactModel>? paidContactList;

  void fetchPaidContacts() async {
    setState(ViewState.Busy);
    try{
      paidContactList = await firebaseFirestoreServices.getPaidContacts();

    }catch(e){

    }
    setState(ViewState.Idle);
  }

  updateContactLocal(ContactModel? model, {bool shouldAdd = false}) {
    if (shouldAdd) {
      if (paidContactList == null) {
        paidContactList = [];
        paidContactList?.add(model!);
      } else {
        paidContactList?.insert(0, model!);
      }
    } else {
      print(model?.reference?.id.toString() ?? "null <============");
      int? index = paidContactList?.indexWhere((element) => element.docId == model?.docId);
      print("INDEX FOR UPDATE LOCAL $index");
      if (index != null && index >= 0) {
        paidContactList![index] = model!;
      }
    }

    setState(ViewState.Idle);
  }

  deletePaidContact(ContactModel? model) async{
    Get.back();
    print("***deleteing contact");
    paidContactList?.removeWhere((element) => element.docId == model?.docId);
   await firebaseFirestoreServices.deletePaidContact(model!);

   CustomSnackBar.showCustomToast(message: "Paid Contact Deleted "
       "Successfully");
    setState(ViewState.Idle);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('ContactsController onInit');
    fetchPaidContacts();
  }
}

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
  }
}