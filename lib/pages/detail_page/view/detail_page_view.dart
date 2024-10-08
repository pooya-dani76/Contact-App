import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/number_tile.dart';

// ignore: must_be_immutable
class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  DetailPageController detailPageController =
      Get.put(DetailPageController(contactBaseInfo: Get.arguments));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailPageController>(builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              title: '',
              leading: [
                CustomButton(
                  onTap: () {},
                  color: Colors.blue,
                  maxSize: const Size(35, 35),
                  child: const Icon(Icons.edit_rounded),
                ),
              ],
              trailing: const [
                Spacer(),
                CustomBackButton(),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const BouncingScrollPhysics(),
                children: [
                  Center(
                    child: Avatar(
                      image: controller.contactBaseInfo['pic_path'],
                      maxSize: const Size(150, 150),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                      child: CustomText(
                    text: controller.contactBaseInfo['name'],
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
                          onTap: () {},
                          color: Colors.red,
                          maxSize: const Size(40, 40),
                          child: const Icon(CupertinoIcons.mail_solid),
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          onTap: () {},
                          color: Colors.blue,
                          maxSize: const Size(40, 40),
                          child: const Icon(CupertinoIcons.bubble_left_fill),
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          onTap: () {},
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
                  const NumberTile(number: '09125085229'),
                  const NumberTile(number: '09125085229'),
                  const NumberTile(number: '09125085229'),
                  const NumberTile(number: '09125085229'),
                  const NumberTile(number: '09125085229'),
                  const NumberTile(number: '09125085229'),
                  const NumberTile(number: '09125085229'),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
