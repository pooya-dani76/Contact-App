import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/utils/utils.dart';

class EditPageController extends GetxController {
  Map? info;
  Map? contact;
  String? picPath;
  TextEditingController nameController = TextEditingController();
  List numberControllers = [
    {
      'country_code': '98',
      'country_symbol': 'IR',
      'number': TextEditingController(),
      'is_valid': false
    }
  ];
  List emailControllers = [];
  List<Map> addresses = [];

  EditPageController({this.info});

  @override
  void onInit() {
    loadContactData();
    super.onInit();
  }

  void addNumber() {
    numberControllers.add({
      'country_code': '98',
      'country_symbol': 'IR',
      'number': TextEditingController(),
      'is_valid': false
    });
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
    routeToPage(page: Routes.mapPage);
    // addresses.add({'latitude': 0, 'longitude': 0});
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
    if (info != null) {
      contact = await Storage.getContactInfo(contactId: info!['contact_id']);
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
        if (numberControllers.isEmpty) {
          addNumber();
        }
        //todo: load addresses
      } else {
        Utils.showToast(message: 'مشکلی در بارگذاری مخاطب وجود دارد', isError: true);
      }
    }
    update();
  }
}

Future<bool> numbersAreValid() async {
  EditPageController editPageController = Get.find();
  if (editPageController.numberControllers[0]['number'].text.isEmpty) {
    return false;
  }
  if (editPageController.numberControllers
      .map((number) => number['is_valid'])
      .toList()
      .any((element) => element == false)) {
    return false;
  }
  return true;
}

Future<bool> emailsAreValid() async {
  EditPageController editPageController = Get.find();
  if (editPageController.emailControllers
      .map((email) => email.text)
      .toList()
      .any((element) => !Utils.isValidEmail(email: element))) {
    return false;
  }
  return true;
}

Future<bool> nameIsValid() async {
  EditPageController editPageController = Get.find();
  return editPageController.nameController.text.trim().isNotEmpty;
}

Future<bool> saveContact() async {
  EditPageController editPageController = Get.find();
  bool response = await Storage.addContact(contactData: {
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
  return response;
}

Future<bool> updateExistingContact() async {
  EditPageController editPageController = Get.find();
  bool response = await Storage.updateContact(contactData: {
    'base': {
      'id': editPageController.contact!['base']['id'],
      'name': editPageController.nameController.text.trim(),
      'picture_path': editPageController.picPath,
      'is_me': editPageController.info!.containsKey('me') ? 1 : 0,
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
  return response;
}

Future<void> onSubmitTap({required bool isUpdate}) async {
  HomePageController homePageController = Get.find();
  bool isSuccess;

  if (await nameIsValid()) {
    if (await numbersAreValid()) {
      if (await emailsAreValid()) {
        if (isUpdate) {
          isSuccess = await updateExistingContact();
          if (isSuccess) {
            try {
              DetailPageController detailPageController = Get.find();
              detailPageController.getContactInfo();
            } catch (e) {
              Utils.logEvent(message: 'DetailPageController Not Put!', logType: LogType.warning);
            }
            homePageController.loadData();
            Get.back();
            Utils.showToast(message: 'مخاطب با موفقیت ویرایش شد.', isError: false);
          } else {
            Utils.showToast(message: 'خطا در ویرایش مخاطب', isError: true);
          }
        } else {
          isSuccess = await saveContact();
          if (isSuccess) {
            homePageController.loadData();
            routeToPage(page: Routes.homePage, clearPreviousPages: true);
            Utils.showToast(message: 'مخاطب با موفقیت ذخیره شد.', isError: false);
          } else {
            Utils.showToast(
                message: 'یکی از شماره های ثبت شده متعلق به مخاطب دیگری است', isError: true);
          }
        }
      } else {
        Utils.showToast(message: 'لطفا ایمیل ها را به شکل صحیح وارد نمایید', isError: true);
      }
    } else {
      Utils.showToast(message: 'لطفا شماره ها را به شکل صحیح وارد نمایید', isError: true);
    }
  } else {
    Utils.showToast(message: 'نام نباید خالی باشد', isError: true);
  }
}
