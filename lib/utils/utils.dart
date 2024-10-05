import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
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
}
