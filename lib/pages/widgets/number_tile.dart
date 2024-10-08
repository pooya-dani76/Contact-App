import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class NumberTile extends StatelessWidget {
  const NumberTile({super.key, required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.bubble_left_fill),
        ),
        IconButton(
          onPressed: () {},
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
