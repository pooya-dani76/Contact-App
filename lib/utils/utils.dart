import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';

enum LogType { trace, debug, info, warning, error }

class Utils {
  static void logEvent({required String message, required LogType logType}) {
    Logger logger = Logger();
    switch (logType) {
      case LogType.trace:
        logger.t(message.toString().tr);
        break;
      case LogType.debug:
        logger.d(message.toString().tr);
        break;
      case LogType.info:
        logger.i(message.toString().tr);
        break;
      case LogType.warning:
        logger.w(message.toString().tr);
        break;
      case LogType.error:
        logger.e(message.toString().tr);
        break;
    }
  }

  static showToast({
    required String message,
    required bool isError,
  }) async {
    await Flushbar(
      isDismissible: true,
      messageText: Directionality(
          textDirection: TextDirection.rtl,
          child: CustomText(
            text: message.tr,
            maxLine: 2,
            fontSize: 12,
            color: Colors.white,
          )),
      icon: Icon(
        isError ? Icons.dangerous_outlined : Icons.done_rounded,
        size: 28.0,
        color: isError ? Colors.red : Colors.green,
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: isError ? Colors.red : Colors.green,
    ).show(Get.context!);
  }

  static Future<void> getPermission({required Directory copyTo}) async {
    if (await copyTo.exists()) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
    } else {
      Utils.logEvent(message: "not exist", logType: LogType.error);
      if (await Permission.manageExternalStorage.request().isGranted) {
        await copyTo.create();
      } else {
        Utils.logEvent(message: 'Please give permission', logType: LogType.error);
      }
    }
  }

  static Future<void> createBackupFile() async {
    Directory copyTo = Directory("storage/emulated/0/Super Phone Book");
    await getPermission(copyTo: copyTo);

    File backupFile = File('${copyTo.path}/backup_contacts.json');

    try {
      Map data = await Storage.getDataAsMap();
      backupFile = await backupFile.writeAsString(jsonEncode(data));
      showToast(message: 'فایل پشتیبان در پوشه ${copyTo.path} قرار داده شد', isError: false);
    } catch (e) {
      logEvent(message: e.toString(), logType: LogType.error);
      showToast(message: 'پشتیبان گیری ناموفق بود', isError: true);
    }
  }

  static Future<void> restoreBackup() async {
    // showToast(message: 'در حال بازگردانی مخاطبین...', isError: false);
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(type: FileType.any);
    if (pickedFile != null) {
      try {
        File files = File(pickedFile.files.single.path.toString());
        Box box = await Storage.openContactsBox();
        await box.clear();
        Map<String, dynamic> data = jsonDecode(await files.readAsString());
        for (var key in data.keys.toList()) {
          Contact contact = Contact(
            id: data[key]['id'],
            name: data[key]['name'],
            numbers: List<String>.from(data[key]['numbers']),
            picturePath: data[key]['picturePath'],
          );
          await Storage.addContact(contact: contact, id: int.parse(key));
        }
        showToast(message: 'بازگردانی با موفقیت انجام شد', isError: false);
      } catch (e) {
        showToast(message: 'خطا در بازگردانی اطلاعات', isError: true);
        logEvent(message: e.toString(), logType: LogType.error);
      }
    }
  }
}
