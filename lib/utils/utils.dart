import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
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

  static showBottomSheet(
      {required String message,
      required VoidCallback onYesTap,
      required VoidCallback onNoTap,
      Color? yesColor,
      Color? noColor}) {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Material(
          color: const Color(0xffefedd4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(text: message, fontWeight: FontWeight.bold),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      maxSize: const Size(100, 50),
                      onTap: onYesTap,
                      child: CustomText(
                        text: 'بله',
                        color: yesColor ?? Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30),
                    CustomButton(
                      maxSize: const Size(100, 50),
                      onTap: onNoTap,
                      child: CustomText(
                        text: 'خیر',
                        fontWeight: FontWeight.bold,
                        color: noColor ?? const Color(0xff78c7bc),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static bool isValidEmail({required String email}) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}
