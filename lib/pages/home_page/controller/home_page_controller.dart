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
    data = await Storage.getAllContacts();
    update();
  }

  Future<void> search() async {
    data = await Storage.searchContact(search: searchController.text);
    update();
  }
}

void onCloseSearchButtonTap() {
  HomePageController homePageController = Get.find();
  homePageController.setSearchMode(false);
  homePageController.searchController.clear();
  homePageController.loadData();
}

void onSearchValueChanged(value) {
  HomePageController homePageController = Get.find();
  Future.delayed(
    const Duration(milliseconds: 500),
    (){
      if (value == homePageController.searchController.text) {
        homePageController.search();
      }
    },
  );
}
