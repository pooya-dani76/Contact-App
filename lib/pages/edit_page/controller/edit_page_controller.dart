import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';

class EditPageController extends GetxController {
  final Map? info;
  String picPath = '';
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> numberControllers = [TextEditingController()];

  EditPageController({this.info});

  void setControllerText({required TextEditingController controller, required String text}) {
    controller.text = text;
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
      // File file = File(result.files.single.path!);
      // CroppedFile? croppedFile = await ImageCropper().cropImage(
      //   sourcePath: File(result.files.single.path!).path,
      //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      // );
      // if (croppedFile != null) {
      // picPath = croppedFile.path;
      picPath = result.files.single.path!;
      update();
      // }
    }
  }

  Future<void> saveContact() async {
    HomePageController homePageController = Get.find();
    if (nameController.text.isNotEmpty && numberControllers[0].text.isNotEmpty) {
      Contact contact = Contact(
          name: nameController.text,
          picturePath: picPath,
          numbers: numberControllers.map((element) => element.text).toList());
        bool isCreated = await Storage.createBaseContact(contact: contact);
        if (isCreated) {
            await Storage.addContactNumbers(contact: contact);
            Get.back();
            homePageController.loadData();
            Utils.showToast(message: 'مخاطب با موفقیت ذخیره شد', isError: false);
        }
        else{
          Utils.showToast(message: 'خطا در ذخیره سازی مخاطب', isError: true);
        }
    }
    else{
      Utils.showToast(message: 'نام مخاطب و شماره آن نمی‌تواند خالی باشد', isError: true);
    }
  }
}
