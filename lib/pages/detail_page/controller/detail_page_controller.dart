import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
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
  showCupertinoModalBottomSheet(
    context: Get.context!,
    builder: (context) {
      return Material(
        color: const Color(0xffefedd4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                  text: 'آیا از حذف این مخاطب اطمینان دارید؟', fontWeight: FontWeight.bold),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    maxSize: const Size(100, 50),
                    onTap: () async {
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
                    child: const CustomText(
                      text: 'بله',
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 30),
                  CustomButton(
                    maxSize: const Size(100, 50),
                    onTap: () => Get.back(),
                    child: const CustomText(
                      text: 'خیر',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff78c7bc),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
