import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class NumberTile extends StatelessWidget {
  const NumberTile(
      {super.key,
      required this.number,
      required this.onBubbleMessageTap,
      required this.onPhoneTap});

  final String number;
  final VoidCallback onBubbleMessageTap;
  final VoidCallback onPhoneTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBubbleMessageTap,
          icon: const Icon(CupertinoIcons.bubble_left_fill),
        ),
        IconButton(
          onPressed: onPhoneTap,
          icon: const Icon(CupertinoIcons.phone_fill),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomText(text: number, fontSize: 15),
        ),
      ],
    );
  }
}
