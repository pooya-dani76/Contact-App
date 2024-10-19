import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/routes/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    HomePageController homePageController = Get.find();
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onMyPicTap,
              child: DrawerHeader(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Avatar(
                        image: homePageController.me!.picturePath ?? '',
                        maxSize: const Size(80, 80),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text: homePageController.me!.name ?? 'بدون نام',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              )),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const CustomText(text: 'تنظیمات', fontWeight: FontWeight.bold),
              onTap: () => routeToPage(page: Routes.settingPage),
            ),
            const Spacer(),
            CustomText(
              text: 'Super Phone Book App V $version',
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
