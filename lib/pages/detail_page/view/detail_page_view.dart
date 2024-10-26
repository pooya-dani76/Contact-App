import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/detail_page/controller/detail_page_controller.dart';
import 'package:special_phone_book/pages/detail_page/view/addresses_show.dart';
import 'package:special_phone_book/pages/detail_page/view/emails_show.dart';
import 'package:special_phone_book/pages/detail_page/view/numbers_show.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/loading_indicator.dart';
import 'package:special_phone_book/pages/widgets/page_header.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    Get.put(DetailPageController(contactId: Get.arguments));
    super.initState();
  }

  @override
  void dispose() {
    DetailPageController detailPageController = Get.find();
    detailPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailPageController>(builder: (detailPageController) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: '',
                leading: [
                  CustomBackButton(),
                  Spacer(),
                ],
              ),
              Expanded(
                  child: detailPageController.contact != null
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            PageHeader(
                              name: detailPageController.contact!['base']['name'],
                              picturePath: detailPageController.contact!['base']['picture_path'],
                              leftIcon: Icons.edit_rounded,
                              rightIcon: Icons.delete_outline_rounded,
                              onRightButtonTap: deleteContact,
                              onLeftButtonTap: onEditTap,
                            ),
                            const SizedBox(height: 60),
                            NumbersShow(numbers: detailPageController.contact!['numbers']),
                            const SizedBox(height: 40),
                            EmailsShow(emails: detailPageController.contact!['emails']),
                            const SizedBox(height: 40),
                            AddressesShow(addresses: detailPageController.contact!['addresses']),
                            const SizedBox(height: 60),
                          ],
                        )
                      : const Center(child: LoadingIndicator())),
            ],
          ),
        ),
      );
    });
  }
}
