import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';

class EditPageController extends GetxController {
  int? contactId;
  Map? contact;
  String? picPath;
  TextEditingController nameController = TextEditingController();
  List numberControllers = [
    {'country_code': '98', 'country_symbol': 'IR', 'number': TextEditingController()}
  ];
  List emailControllers = [];
  List<Map> addresses = [];

  EditPageController({this.contactId});

  @override
  void onInit() {
    loadContactData();
    super.onInit();
  }

  void addNumber() {
    numberControllers
        .add({'country_code': '98', 'country_symbol': 'IR', 'number': TextEditingController()});
    update();
  }

  void removeNumber({required int index}) {
    numberControllers.removeAt(index);
    update();
  }

  void addEmail() {
    emailControllers.add(TextEditingController());
    update();
  }

  void removeEmail({required int index}) {
    emailControllers.removeAt(index);
    update();
  }

  void addAddress() {
    update();
  }

  void removeAddress({required int index}) {
    update();
  }

  Future<File?> cropImage({required File imageFile}) async {
    try {
      CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'برش عکس نمایه',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.black,
            activeControlsWidgetColor: Colors.red,
          ),
        ],
      );
      if (croppedImg == null) {
        return null;
      } else {
        return File(croppedImg.path);
      }
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
    }
    return null;
  }

  Future<void> setPicture() async {
    XFile? photo = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    File? tempImage = File(photo!.path);
    tempImage = await cropImage(imageFile: tempImage);
    picPath = tempImage!.path;
    update();
  }

  void onChangeCountry({required Country country, required int index}) {
    numberControllers[index]['country_code'] = country.dialCode;
    numberControllers[index]['country_symbol'] = country.code;
    update();
  }

  Future<void> loadContactData() async {
    if (contactId != null) {
      contact = await Storage.getContactInfo(contactId: contactId!);
      if (contact != null) {
        picPath = contact!['base']['picture_path'];
        nameController.text = contact!['base']['name'];
        numberControllers.clear();
        numberControllers.addAll(contact!['numbers']
            .map((number) => {
                  'country_code': number['country_code'],
                  'country_symbol': number['country_symbol'],
                  'number': TextEditingController(text: number['number'])
                })
            .toList());
        emailControllers =
            contact!['emails'].map((email) => TextEditingController(text: email['email'])).toList();
        //todo: load addresses
      } else {
        Utils.showToast(message: 'مشکلی در بارگذاری مخاطب وجود دارد', isError: true);
      }
    }
    update();
  }
}

Future<void> saveContact() async {
  EditPageController editPageController = Get.find();
  await Storage.addContact(contactData: {
    'base': {
      'name': editPageController.nameController.text.trim(),
      'picture_path': editPageController.picPath,
      'is_me': 0,
    },
    'numbers': editPageController.numberControllers
        .map((element) => {
              'country_code': element['country_code'],
              'country_symbol': element['country_symbol'],
              'number': element['number'].text
            })
        .toList(),
    'emails': editPageController.emailControllers.map((element) => element.text).toList(),
    'addresses': editPageController.addresses
  });
}

Future<void> updateExistingContact({required Contact contact}) async {}

Future<void> onSubmitTap({required bool isUpdate}) async {
  // EditPageController editPageController = Get.find();
  HomePageController homePageController = Get.find();
  await saveContact();
  homePageController.loadData();
  routeToPage(page: Routes.homePage, clearPreviousPages: true);
}

Future<void> deleteContact() async {
  HomePageController homePageController = Get.find();
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
                    onTap: () => Get.back(),
                    child: const CustomText(
                      text: 'خیر',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff78c7bc),
                    ),
                  ),
                  const SizedBox(width: 30),
                  CustomButton(
                    maxSize: const Size(100, 50),
                    onTap: () async {
                      bool isSuccess = ''.isEmpty;
                      // await Storage.deleteContact(contactId: editPageController.contact!.id!);
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
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
