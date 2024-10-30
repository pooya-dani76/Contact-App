import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/setting_page/controller/setting_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingPageController>(
      builder: (settingPageController) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                const CustomAppBar(
                  title: 'تنظیمات',
                  leading: [
                    CustomBackButton(),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.backup_sharp),
                          title: CustomText(text: 'پشتیبان گیری'),
                          onTap: onBackupTap,
                        ),
                        ListTile(
                          leading: Icon(Icons.restore_outlined),
                          title: CustomText(text: 'بازگردانی'),
                          onTap: onRestoreTap,
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_outline_rounded),
                          title: CustomText(text: 'حذف مشخصات وارد شده شما'),
                          onTap: removeMySelfInfo,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                FutureBuilder(
                  future: getAppVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomText(text: snapshot.data!, fontSize: 9);
                    } else {
                      return const SizedBox(height: 0, width: 0);
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
