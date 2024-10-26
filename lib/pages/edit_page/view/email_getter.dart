import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';

class EmailGetter extends StatelessWidget {
  const EmailGetter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPageController>(builder: (editPageController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CustomText(
            text: 'ایمیل‌های مخاطب',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          const SizedBox(height: 15),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: editPageController.emailControllers.length,
            itemBuilder: (context, index) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(
                      onTap: () => editPageController.removeEmail(index: index),
                      maxSize: const Size(40, 40),
                      child: const Icon(CupertinoIcons.minus),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: CustomTextField(
                      controller: editPageController.emailControllers[index],
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                    )),
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: editPageController.addEmail,
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
                        text: 'اضافه کردن ایمیل',
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )),
          ),
        ],
      );
    });
  }
}
