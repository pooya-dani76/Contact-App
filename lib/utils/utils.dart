import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

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
      // backgroundColor: const Color(0xffefedd4),
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

  static bool isValidEmail({required String email}) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
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

  static Future<void> createBackupFile() async {}

  static Future<void> restoreBackup() async {}
}
