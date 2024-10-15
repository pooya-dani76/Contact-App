import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/contact_card.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';
import 'package:special_phone_book/pages/widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<HomePageController>(
            builder: (homePageController) => homePageController.searchMode
                ? Container(
                    padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                    height: 80,
                    child: Row(
                      children: [
                        CustomButton(
                          onTap: () => onCloseSearchButtonTap(),
                          color: Colors.red,
                          maxSize: const Size(35, 35),
                          child: const Icon(Icons.close_rounded),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                              controller: homePageController.searchController,
                              maxLines: 1,
                              autofocus: true,
                              onChanged: onSearchValueChanged),
                        ),
                      ],
                    ),
                  )
                : CustomAppBar(
                    title: 'مخاطبین',
                    leading: [
                      const CustomButton(
                        onTap: onAddContactTap,
                        color: Colors.blue,
                        maxSize: Size(35, 35),
                        child: Icon(Icons.add),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onTap: onSearchButtonTap,
                        color: Colors.greenAccent[400],
                        maxSize: const Size(35, 35),
                        child: const Icon(Icons.search_rounded),
                      ),
                    ],
                    trailing: [
                      const Spacer(),
                      InkWell(
                        onTap: onMyPicTap,
                        child: Avatar(
                          image: homePageController.myPicPath ?? '',
                          maxSize: const Size(35, 35),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GetBuilder<HomePageController>(builder: (homePageController) {
              return ModalProgressHUD(
                  inAsyncCall: homePageController.data == null,
                  progressIndicator: const LoadingIndicator(),
                  child: homePageController.data != null
                      ? (homePageController.data!.isEmpty
                          ? const Center(
                              child: CustomText(
                                text: 'مخاطبی ذخیره نشده است',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => ContactCard(
                                contactId: homePageController.data![index].id,
                                avatar: homePageController.data![index].picturePath,
                                name: homePageController.data![index].name,
                              ),
                              itemCount: homePageController.data!.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                childAspectRatio: 0.8,
                              ),
                            ))
                      : Container());
            }),
          ),
        ],
      ),
    );
  }
}
