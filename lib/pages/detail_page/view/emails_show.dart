import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/email_tile.dart';

class EmailsShow extends StatelessWidget {
  const EmailsShow({super.key, required this.emails});

  final List emails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomText(
          text: 'ایمیل‌ها',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        const SizedBox(height: 20),
        Column(
          children: emails.map<Widget>((email) => EmailTile(email: email['email'])).toList(),
        ),
      ],
    );
  }
}
