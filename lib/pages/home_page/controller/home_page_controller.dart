import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';

class HomePageController extends GetxController {
  List? data;
  bool searchMode = false;
  Contact? me;
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
    await setMyInfo();
    update();
  }

  Future<void> search() async {
    data = await Storage.searchContact(search: searchController.text);
    update();
  }

  Future<void> setMyInfo() async {
    me = await Storage.getMyInfo();
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
    () {
      if (value == homePageController.searchController.text) {
        homePageController.search();
      }
    },
  );
}

void onAddContactTap() {
  routeToPage(page: Routes.editPage);
}

void onSearchButtonTap() {
  HomePageController homePageController = Get.find();
  homePageController.setSearchMode(true);
}

void onMyPicTap() {
  routeToPage(page: Routes.editPage, arguments: {'me': true});
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

