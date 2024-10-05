import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailPageController>(builder: (detailPageController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const CustomText(
            text: 'ایجاد مخاطب جدید',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Avatar(
                image: 'assets/images/unknown_person.png',
              ),
            ),
            const SizedBox(height: 50),
            CustomTextField(
              controller: detailPageController.nameController,
              label: 'نام مخاطب',
            )
          ],
        ),
      );
    });
  }
}
