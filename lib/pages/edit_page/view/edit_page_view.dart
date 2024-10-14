import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
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
          CustomAppBar(
            title: Get.arguments != null ? 'ویرایش مخاطب' :'افزودن مخاطب',
            trailing: const [Spacer(), CustomBackButton()],
            leading: [
              CustomButton(
                onTap: () => onSubmitTap(isUpdate: Get.arguments != null),
                child: const Icon(CupertinoIcons.check_mark),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: GetBuilder<EditPageController>(builder: (editPageController) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: InkWell(
                    onTap: editPageController.setPicture,
                    child: Avatar(
                      image: editPageController.picPath ?? '',
                      maxSize: const Size(150, 150),
                    ),
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
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                        children: [
                          if (editPageController.numberControllers.length > 1) ...{
                            CustomButton(
                              onTap: () => editPageController.removeNumber(index: index),
                              maxSize: const Size(40, 40),
                              color: Colors.red,
                              child: const Icon(CupertinoIcons.minus),
                            ),
                            const SizedBox(width: 15),
                          },
                          Expanded(
                            child: CustomTextField(
                              controller: editPageController.numberControllers[index],
                              onlyNumeric: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: editPageController.addNumber,
                  child: DottedBorder(
                      radius: const Radius.circular(15),
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              color: Colors.grey,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            CustomText(
                              text: 'اضافه کردن شماره',
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            );
          }))
        ],
      ),
    );
  }
}
