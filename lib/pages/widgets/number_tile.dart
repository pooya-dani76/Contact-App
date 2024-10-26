import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NumberTile extends StatelessWidget {
  const NumberTile({super.key, required this.number, required this.countryCode});

  final String number;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              CustomText(text: '+$countryCode', fontSize: 15, textDirection: TextDirection.ltr),
              const SizedBox(width: 3),
              CustomText(text: number, fontSize: 15),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => onBubbleMessageTap(number: countryCode + number),
          icon: const Icon(CupertinoIcons.bubble_left_fill),
        ),
        IconButton(
          onPressed: () => onPhoneTap(number: countryCode + number),
          icon: const Icon(CupertinoIcons.phone_fill),
        ),
      ],
    );
  }
}

void onBubbleMessageTap({required String number}) async {
  try {
    await launchUrlString("sms:${'+$number'}");
  } catch (e) {
    Utils.logEvent(message: 'Can Send SMS to ${'+$number'}', logType: LogType.error);
  }
}

void onPhoneTap({required String number}) async {
  try {
    await FlutterPhoneDirectCaller.callNumber(number);
  } catch (e) {
    Utils.logEvent(message: 'Can Make Call to ${'+$number'}', logType: LogType.error);
  }
}
