import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class AddressesShow extends StatelessWidget {
  const AddressesShow({super.key, required this.addresses});

  final List addresses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomText(
          text: 'آدرس‌ها',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        const SizedBox(height: 20),
        Column(
          children: addresses.map<Widget>((email) => const SizedBox()).toList(),
          //TODO: Addresses Show Implement
        ),
      ],
    );
  }
}
