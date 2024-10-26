import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_phone_input_field.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class NumberGetter extends StatelessWidget {
  const NumberGetter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPageController>(builder: (editPageController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CustomText(
            text: 'شماره‌های مخاطب',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          const SizedBox(height: 15),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: editPageController.numberControllers.length,
            itemBuilder: (context, index) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (editPageController.numberControllers.length > 1) ...{
                      CustomButton(
                        onTap: () => editPageController.removeNumber(index: index),
                        maxSize: const Size(40, 40),
                        child: const Icon(CupertinoIcons.minus),
                      ),
                      const SizedBox(width: 15),
                    },
                    Expanded(
                        child: CustomPhoneInputField(
                      controller: editPageController.numberControllers[index]['number'],
                      initCountryCode: editPageController.numberControllers[index]['country_symbol'],
                      onCountryChanged: (country) =>
                          editPageController.onChangeCountry(country: country, index: index),
                    )),
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
    });
  }
}
