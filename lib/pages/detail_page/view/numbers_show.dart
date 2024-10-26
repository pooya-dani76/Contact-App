import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/number_tile.dart';

class NumbersShow extends StatelessWidget {
  const NumbersShow({super.key, required this.numbers});

  final List numbers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomText(
          text: 'شماره‌ها',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        const SizedBox(height: 20),
        Column(
          children: numbers
              .map<Widget>(
                (number) => NumberTile(
                  countryCode: number['country_code'],
                  number: number['number'],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
