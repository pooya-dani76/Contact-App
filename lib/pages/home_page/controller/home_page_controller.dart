import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/storage/functions/functions.dart';

class HomePageController extends GetxController {
  List? data;
  bool searchMode = false;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  setSearchMode(bool mode) {
    searchMode = mode;
    update();
  }

  Future<void> loadData() async {
    data = await Storage.getContacts();
    update();
  }

  Future<void> search() async {
    data = await Storage.searchContact(searchText: searchController.text);
    update();
  }
}

void onCloseSearchButtonTap() {
  HomePageController homePageController = Get.find();
  homePageController.setSearchMode(false);
  homePageController.searchController.clear();
  homePageController.loadData();
}
