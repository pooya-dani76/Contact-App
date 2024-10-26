import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EmailTile extends StatelessWidget {
  const EmailTile({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:CustomText(text: email, fontSize: 15),
        ),
        const Spacer(),
        IconButton(
          onPressed: ()=> onMailTap(email: email),
          icon: const Icon(CupertinoIcons.mail_solid),
        ),
      ],
    );
  }
}

void onMailTap({required String email}) async {
  try {
    await launchUrlString("mailto:$email");
  } catch (e) {
    Utils.logEvent(message: 'Can Send Email to $email', logType: LogType.error);
  }
}
