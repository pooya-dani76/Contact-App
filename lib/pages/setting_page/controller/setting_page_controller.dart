import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/utils/utils.dart';

class SettingPageController extends GetxController {
  bool isBackup = false;
  bool isRestore = false;

  void setBackupMode(bool status) {
    isBackup = status;
    update();
  }

  void setRestoreMode(bool status) {
    isRestore = status;
    update();
  }
}

Future<void> onRestoreTap() async {
  SettingPageController settingPageController = Get.find();
  HomePageController homePageController = Get.find();
  settingPageController.setRestoreMode(true);
  await Utils.restoreBackup();
  settingPageController.setRestoreMode(false);
  homePageController.loadData();
  routeToPage(page: Routes.homePage, clearPreviousPages: true);
}

Future<void> onBackupTap() async {
  SettingPageController settingPageController = Get.find();
  settingPageController.setBackupMode(true);
  await Utils.createBackupFile();
  settingPageController.setBackupMode(false);
  
}