import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

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

Future<void> getPermission() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  if (int.parse(androidInfo.version.release.split('.')[0]) < 13) {
    if (await Permission.storage.status == PermissionStatus.denied) {
      await Permission.storage.request();
    }
  } else {
    if (await Permission.manageExternalStorage.status == PermissionStatus.denied) {
      await Permission.manageExternalStorage.request();
    }
  }
}

Future<void> onRestoreTap() async {
  HomePageController homePageController = Get.find();
  var databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'super_phone_book.db');
  File database = File(dbPath);

  FilePickerResult? result = await FilePicker.platform.pickFiles(initialDirectory: databasesPath);

  if (result != null) {
    if (result.files.single.path!.split('/').last == "super_phone_book.db") {
      await Utils.showBottomSheet(
          noColor: Colors.red,
          yesColor: const Color(0xff78c7bc),
          message: "آیا برای بازگردانی به فایل انتخاب شده مطمئن هستید؟",
          onYesTap: () async {
            await database.delete();
            File source = File(result.files.single.path!);
            await source.copy(dbPath);
            Get.back();
            homePageController.loadData();
            routeToPage(page: Routes.homePage, clearPreviousPages: true);
          },
          onNoTap: () => Get.back());
    } else {
      Utils.showToast(message: "فایل انتخاب شده نامعتبر است", isError: true);
    }
  }
}

Future<void> onBackupTap() async {
  final dbFolder = await getDatabasesPath();
  File source1 = File('$dbFolder/super_phone_book.db');
  Directory copyTo = Directory("storage/emulated/0/Super Phone Book");

  await getPermission();

  if (!await copyTo.exists()) {
    await copyTo.create();
  }
  try {
    String newPath = "${copyTo.path}/super_phone_book.db";
    await source1.copy(newPath);
    Utils.showToast(
        message: "فایل پایگاه داده در پوشه Super Phone Book/super_phone_book.db ذخیره شد.",
        isError: false);
  } catch (e) {
    Utils.logEvent(message: e.toString(), logType: LogType.error);
    Utils.showToast(message: "خطا در گرفتن نسخه پشتیبان", isError: true);
  }
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return '${packageInfo.appName} v${packageInfo.version}';
}

void removeMySelfInfo() {
  HomePageController homePageController = Get.find();
  Utils.showBottomSheet(
    message: 'آیا از حذف مشخصات خودتان اطمینان دارید؟',
    onYesTap: () async {
      Map me = await Storage.getMyInfo() ?? {};
      Map contactData = {
        'base': {'id': me['id'], 'name': '', 'picture_path': null, 'is_me': 1},
        'numbers': [],
        'emails': [],
        'addresses': [],
      };
      bool isSuccess = await Storage.updateContact(contactData: contactData);
      if (isSuccess) {
        Get.back();
        homePageController.loadData();
        routeToPage(page: Routes.homePage, clearPreviousPages: true);
        Utils.showToast(message: 'مشخصات شما با موفقیت حذف شد', isError: false);
      } else {
        Utils.showToast(message: 'خطا در حذف مشخصات شما', isError: true);
      }
    },
    onNoTap: () => Get.back(),
  );
}
