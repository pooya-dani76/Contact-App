import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/storage/models/models.dart';

class EditPageController extends GetxController {
  final Map? info;
  String picPath = '';
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> numberControllers = [TextEditingController()];

  EditPageController({this.info});

  @override
  void onInit() {
    loadContactData();
    super.onInit();
  }

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

  Future<void> saveContact({required Contact contact}) async {
    
  }

  Future<void> updateExistingContact({required Contact contact}) async {
    
  }

  Future<void> onSubmitTap({required bool isUpdate}) async {
    
  }

  Future<void> loadContactData() async {
    if (info != null) {
      numberControllers.clear();
      picPath = info!['base']['pic_path'];
      for (var number in info!['numbers']) {
        numberControllers.add(TextEditingController(text: number['number']));
      }
      nameController.text = info!['base']['name'];
      update();
    }
  }
}
