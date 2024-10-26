import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: const Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(
          CupertinoIcons.back,
          color: Color(0xff78c7bc),
          size: 30,
        ),
      ),
    );
  }
}
