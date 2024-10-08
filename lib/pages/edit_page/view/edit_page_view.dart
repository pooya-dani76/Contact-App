import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class EditPage extends StatelessWidget {
  EditPage({super.key});

  EditPageController editPageController = Get.put(EditPageController(info: Get.arguments));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(
            title: 'افزودن مخاطب',
            trailing: [Spacer(), CustomBackButton()],
          ),
          const SizedBox(height: 20),
          Expanded(child: GetBuilder<EditPageController>(builder: (editPageController) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: Avatar(
                    image: editPageController.picPath ?? '',
                    maxSize: const Size(150, 150),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: editPageController.nameController,
                  label: 'نام مخاطب',
                ),
                const SizedBox(height: 30),
                const CustomText(
                  text: 'شماره‌های مخاطب',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: editPageController.numberControllers.length,
                  itemBuilder: (context, index) => CustomTextField(
                    controller: editPageController.numberControllers[index],
                    onlyNumeric: true,
                  ),
                )
              ],
            );
          }))
        ],
      ),
    );
  }
}
