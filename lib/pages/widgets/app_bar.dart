import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.leading,
  });

  final String title;
  final List<Widget>? trailing;
  final List<Widget>? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Row(children: leading ?? [])),
          Expanded(
            child: Center(
              child: CustomText(
                text: title,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: trailing ?? []
            ),
          ),
        ],
      ),
    );
  }
}
