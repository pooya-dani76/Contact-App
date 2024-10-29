import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class AddressGetter extends StatelessWidget {
  const AddressGetter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPageController>(
      builder: (editPageController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomText(
              text: 'آدرس‌های مخاطب',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.end,
              children: editPageController.addresses
                      .map<Widget>((element) => Container(
                            height: 90,
                            width: 90,
                            color: Colors.red,
                          ))
                      .toList() +
                  <Widget>[
                    InkWell(
                      onTap: editPageController.addAddress,
                      child: SizedBox(
                        height: 90,
                        width: 90,
                        child: DottedBorder(
                          radius: const Radius.circular(15),
                          borderType: BorderType.RRect,
                          color: const Color(0xff78c7bc),
                          child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                  Icons.add_location_rounded,
                                  color: Color(0xff78c7bc),
                                  size: 30,
                                ),
                                SizedBox(height: 5),
                                CustomText(text: 'افزودن آدرس', color: Color(0xff78c7bc), fontSize: 9,)
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
            ),
          ],
        );
      },
    );
  }
}
