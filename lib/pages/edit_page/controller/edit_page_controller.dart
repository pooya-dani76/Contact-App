import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';

class EditPageController extends GetxController {
  Map? info;
  Contact? contact;
  String? picPath;
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> numberControllers = [TextEditingController()];

  EditPageController({this.info});

  @override
  void onInit() {
    loadContactData();
    super.onInit();
  }

  void addNumber() {
    numberControllers.add(TextEditingController());
    update();
  }

  void removeNumber({required int index}) {
    numberControllers.removeAt(index);
    update();
  }

  Future<void> setPicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      picPath = result.files.single.path!;
      update();
    }
  }

  Future<void> loadContactData() async {
    if (info != null) {
      contact = info!['contact'];
      picPath = contact!.picturePath;
      if (contact!.numbers != null) {
        numberControllers.clear();
        for (var number in contact!.numbers!) {
          numberControllers.add(TextEditingController(text: number));
        }
      }
      nameController.text = contact!.name!;
      update();
    }
  }
}

Future<bool> saveContact() async {
  EditPageController editPageController = Get.find();
  bool isSuccess = await Storage.addContact(
      contact: Contact(
    name: editPageController.nameController.text,
    picturePath: editPageController.picPath,
    numbers: editPageController.numberControllers.map((x) => x.text).toList(),
  ));
  return isSuccess;
}

Future<bool> updateExistingContact({required Contact contact}) async {
  EditPageController editPageController = Get.find();
  bool isSuccess = await Storage.updateContact(
      contact: Contact(
    id: contact.id,
    name: editPageController.nameController.text,
    picturePath: editPageController.picPath,
    numbers: editPageController.numberControllers.map((x) => x.text).toList(),
  ));
  return isSuccess;
}

Future<void> onSubmitTap({required bool isUpdate}) async {
  EditPageController editPageController = Get.find();
  HomePageController homePageController = Get.find();
  bool? isSuccess;

  if (isUpdate) {
    isSuccess = await updateExistingContact(contact: editPageController.contact!);
  } else {
    isSuccess = await saveContact();
  }
  if (isSuccess) {
    Get.back();
    Utils.showToast(message: 'عملیات با موفقیت انجام شد', isError: false);
    try {
      DetailPageController detailPageController = Get.find();
      await detailPageController.getContactInfo();
    } catch (e) {
      Utils.logEvent(message: 'DetailPageController Not Put', logType: LogType.error);
    }
    await homePageController.loadData();
  } else {
    Utils.showToast(message: 'خطایی رخ داد', isError: true);
  }
}
