import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.showAddButton, required this.title});

  final bool? showAddButton;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                // onTap: () => routeToPage(page: Routes.detailPage),
                onTap: () async {
                  HomePageController homePageController = Get.find();
                  await Storage.addNewContact(
                      contact: Contact(name: "ایران ای مرز پرگهر", numbers: ['09359777475'], picturePath: ''));
                  homePageController.loadData();
                },
                color: Colors.blue,
                maxSize: const Size(35, 35),
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              CustomButton(
                onTap: (){},
                color: Colors.green,
                maxSize: const Size(35, 35),
                child: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          CustomText(
            text: title,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          const SizedBox(width: 10),
          const Avatar(
            image: '',
            maxSize: Size(35, 35),
          ),
        ],
      ),
    );
  }
}
