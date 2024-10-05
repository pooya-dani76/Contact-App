import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DetailPageController extends GetxController {
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> numberControllers = [
    TextEditingController(),
  ];
}