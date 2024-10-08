import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPageController extends GetxController {
  final Map? info;
  String? picPath;
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> numberControllers = [TextEditingController()];

  EditPageController({this.info});


  void setControllerText({required TextEditingController controller, required String text}) {
    controller.text = text;
  }

  void setPicture() {}
}
