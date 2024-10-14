import 'package:get/get.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';

class DetailPageController extends GetxController {
  Map? contactId;
  Contact? contact;

  DetailPageController({required this.contactId});

  @override
  onInit() {
    getContactInfo();
    super.onInit();
  }

  Future<void> getContactInfo() async {
    contact = await Storage.getContact(contactId: contactId!['id']);
    update();
  }
}

void onEditTap() {
  DetailPageController detailPageController = Get.find();
  routeToPage(
    page: Routes.editPage,
    arguments: {'contact': detailPageController.contact},
  );
}
