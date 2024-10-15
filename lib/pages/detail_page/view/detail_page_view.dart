import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/loading_indicator.dart';
import 'package:special_phone_book/pages/widgets/number_tile.dart';

// ignore: must_be_immutable
class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  DetailPageController detailPageController =
      Get.put(DetailPageController(contactId: Get.arguments));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailPageController>(builder: (controller) {
      return ModalProgressHUD(
        inAsyncCall: controller.contact == null,
        progressIndicator: const LoadingIndicator(),
        child: Scaffold(
          body: Column(
            children: [
              const CustomAppBar(
                title: '',
                leading: [
                  CustomButton(
                    onTap: onEditTap,
                    color: Colors.blue,
                    maxSize: Size(35, 35),
                    child: Icon(Icons.edit_rounded),
                  ),
                ],
                trailing: [
                  Spacer(),
                  CustomBackButton(),
                ],
              ),
              const SizedBox(height: 20),
              if (controller.contact != null) ...{
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Center(
                        child: Avatar(
                          image: controller.contact!.picturePath ?? '',
                          maxSize: const Size(150, 150),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                          child: CustomText(
                        text: controller.contact!.name!,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              onTap: () =>
                                  onBubbleMessageTap(number: controller.contact!.numbers![0]),
                              color: Colors.blue,
                              maxSize: const Size(40, 40),
                              child: const Icon(CupertinoIcons.bubble_left_fill),
                            ),
                            const SizedBox(width: 20),
                            CustomButton(
                              onTap: () => onPhoneTap(number: controller.contact!.numbers![0]),
                              color: Colors.lightGreen,
                              maxSize: const Size(40, 40),
                              child: const Icon(CupertinoIcons.phone_fill),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const CustomText(
                        text: 'شماره‌های مخاطب',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: (controller.contact!.numbers ?? [])
                            .map(
                              (number) => NumberTile(
                                number: number,
                                onBubbleMessageTap: () => onBubbleMessageTap(number: number),
                                onPhoneTap: () => onPhoneTap(number: number),
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ),
                ),
              }
            ],
          ),
        ),
      );
    });
  }
}
