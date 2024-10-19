import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';

class EditPageController extends GetxController {
  Map? info;
  Contact? contact;
  String? picPath;
  bool loadMe = false;
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> numberControllers = [TextEditingController()];

  EditPageController({this.info});

  @override
  void onInit() {
    loadContactData();
    super.onInit();
  }

  bool numbersAllFilled() {
    for (var i = 0; i < numberControllers.length; i++) {
      if (numberControllers[i].text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  void addNumber() {
    numberControllers.add(TextEditingController());
    update();
  }

  void removeNumber({required int index}) {
    numberControllers.removeAt(index);
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

  Future<void> loadContactData() async {
    if (info != null) {
      contact = info!.containsKey('me') ? await Storage.getMyInfo() : info!['contact'];
      picPath = contact!.picturePath;
      if (contact!.numbers != null) {
        numberControllers.clear();
        for (var number in contact!.numbers!) {
          numberControllers.add(TextEditingController(text: number));
        }
      }
      nameController.text = contact!.name ?? '';
      update();
    }
  }
}

Future<void> deleteContact() async {
  HomePageController homePageController = Get.find();
  EditPageController editPageController = Get.find();
  Get.defaultDialog(
    title: 'آیا از حذف این مخاطب اطمینان دارید؟',
    titleStyle: const TextStyle(
      fontFamily: "Vazir",
      fontSize: 16,
    ),
    titlePadding: const EdgeInsets.symmetric(vertical: 20),
    content: Container(),
    cancel: CustomButton(
      maxSize: const Size(100, 50),
      onTap: () => Get.back(),
      color: Colors.grey,
      child: const CustomText(text: 'خیر'),
    ),
    confirm: CustomButton(
      maxSize: const Size(100, 50),
      onTap: () async {
        bool isSuccess = await Storage.deleteContact(contactId: editPageController.contact!.id!);
        if (isSuccess) {
          Get.back();
          await homePageController.loadData();
          routeToPage(page: Routes.homePage, clearPreviousPages: true);
          Utils.showToast(message: 'مخاطب حذف شد', isError: false);
        } else {
          Utils.showToast(message: 'خطایی رخ داد', isError: true);
        }
      },
      color: Colors.red,
      child: const CustomText(text: 'بله'),
    ),
  );
}

Future<bool> saveContact() async {
  EditPageController editPageController = Get.find();
  bool isSuccess = await Storage.addContact(
      contact: Contact(
    name: editPageController.nameController.text.trim(),
    picturePath: editPageController.picPath,
    numbers: editPageController.numberControllers.map((x) => x.text).toList(),
  ));
  return isSuccess;
}

Future<bool> updateExistingContact({required Contact contact}) async {
  EditPageController editPageController = Get.find();
  editPageController.numberControllers.retainWhere((x) => x.text.isNotEmpty);
  Contact newContact = Contact(
    id: contact.id,
    name: editPageController.nameController.text.trim(),
    picturePath: editPageController.picPath,
    numbers: editPageController.numberControllers.map((x) => x.text).toList(),
  );
  bool isSuccess;
  if (editPageController.info!.containsKey('me')) {
    isSuccess = await Storage.saveMyInfo(contact: newContact);
  } else {
    isSuccess = await Storage.updateContact(contact: newContact);
  }
  return isSuccess;
}

Future<void> onSubmitTap({required bool isUpdate}) async {
  EditPageController editPageController = Get.find();
  HomePageController homePageController = Get.find();
  bool? isSuccess;

  if (editPageController.nameController.text.trim().isNotEmpty &&
      editPageController.numberControllers.isNotEmpty) {
    if (editPageController.numbersAllFilled()) {
      if (isUpdate) {
        isSuccess = await updateExistingContact(contact: editPageController.contact!);
      } else {
        isSuccess = await saveContact();
      }
      if (isSuccess) {
        routeToPage(page: Routes.homePage, clearPreviousPages: true);
        Utils.showToast(message: 'عملیات با موفقیت انجام شد', isError: false);
        try {
          DetailPageController detailPageController = Get.find();
          await detailPageController.getContactInfo();
        } catch (e) {
          Utils.logEvent(message: 'DetailPageController Not Put', logType: LogType.error);
        }
        await homePageController.loadData();
      }
    } else {
      Utils.showToast(message: "شماره خالی قابل ذخیره سازی نیست", isError: true);
    }
  } else {
    Utils.showToast(message: "فیلد نام و شماره‌ها نباید خالی باشد", isError: true);
  }
}
