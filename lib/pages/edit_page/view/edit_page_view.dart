import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/edit_page/view/email_getter.dart';
import 'package:special_phone_book/pages/edit_page/view/number_getter.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';
import 'package:special_phone_book/pages/widgets/page_header.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    Get.put(EditPageController(contactId: Get.arguments != null ? Get.arguments['contact_id'] : null));
    super.initState();
  }

  @override
  void dispose() {
    EditPageController editPageController = Get.find<EditPageController>();
    editPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(
              title: '',
              leading: [CustomBackButton(), Spacer()],
            ),
            Expanded(child: GetBuilder<EditPageController>(builder: (editPageController) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  PageHeader(
                    showName: false,
                    picturePath: editPageController.picPath,
                    leftIcon: CupertinoIcons.check_mark,
                    rightIcon: Get.arguments != null ? Icons.delete_outline_rounded : null,
                    onRightButtonTap: Get.arguments != null ? deleteContact : null,
                    onLeftButtonTap: () => onSubmitTap(isUpdate: Get.arguments != null),
                    onAvatarTap: editPageController.setPicture,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: editPageController.nameController,
                    label: 'نام مخاطب',
                  ),
                  const SizedBox(height: 30),
                  const NumberGetter(),
                  const SizedBox(height: 30),
                  const EmailGetter(),
                  const SizedBox(height: 30),
                ],
              );
            }))
          ],
        ),
      ),
    );
  }
}
