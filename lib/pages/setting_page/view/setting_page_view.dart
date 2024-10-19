import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
        return Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: settingPageController.isBackup || settingPageController.isRestore,
            color: Colors.black,
            child: const Column(
              children: [
                CustomAppBar(
                  title: 'تنظیمات',
                  trailing: [
                    Spacer(),
                    CustomBackButton(),
                  ],
                ),
                SizedBox(height: 30),
                Expanded(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
