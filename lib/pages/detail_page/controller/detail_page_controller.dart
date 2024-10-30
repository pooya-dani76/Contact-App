import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions.dart';
import 'package:special_phone_book/utils/utils.dart';

class DetailPageController extends GetxController {
  Map? contactId;
  Map? contact;

  DetailPageController({required this.contactId});

  @override
  onInit() {
    getContactInfo();
    super.onInit();
  }

  Future<void> getContactInfo() async {
    contact = await Storage.getContactInfo(contactId: contactId!['id']);
    update();
  }
}

void onEditTap() {
  DetailPageController detailPageController = Get.find();
  routeToPage(
    page: Routes.editPage,
    arguments: {'contact_id': detailPageController.contactId!['id']},
  );
}

Future<void> deleteContact() async {
  HomePageController homePageController = Get.find();
  DetailPageController detailPageController = Get.find();
  Utils.showBottomSheet(
      message: 'آیا از حذف این مخاطب اطمینان دارید؟',
      onYesTap: () async {
        bool isSuccess =
            await Storage.deleteContact(contactId: detailPageController.contact!['base']['id']);
        if (isSuccess) {
          Get.back();
          await homePageController.loadData();
          routeToPage(page: Routes.homePage, clearPreviousPages: true);
          Utils.showToast(message: 'مخاطب حذف شد', isError: false);
        } else {
          Utils.showToast(message: 'خطایی رخ داد', isError: true);
        }
      },
      onNoTap: () => Get.back());
}
