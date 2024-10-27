import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/page_header.dart';
import 'package:special_phone_book/pages/widgets/contact_card.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';
import 'package:special_phone_book/pages/widgets/loading_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (homePageController) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                if(homePageController.meBase != null)...{
                  PageHeader(
                  name: homePageController.meBase!['name'],
                  picturePath: homePageController.meBase!['picture_path'] ,
                  onLeftButtonTap: onAddContactTap,
                  onRightButtonTap: onSearchButtonTap,
                  rightIcon: homePageController.searchMode ? Icons.close : Icons.search,
                  leftIcon: Icons.add,
                  onAvatarTap: onMyPicTap,
                ),
                },
                if (homePageController.searchMode) ...{
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: homePageController.searchController,
                    prefixIcon: Icons.search,
                    hint: 'جستجو در مخاطبین',
                    onChanged: onSearchValueChanged,
                  ),
                },
                const SizedBox(height: 30),
                Expanded(
                  child: homePageController.data != null
                      ? (homePageController.data!.isNotEmpty
                          ? Directionality(
                              textDirection: TextDirection.rtl,
                              child: GridView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => ContactCard(
                                  contactId: homePageController.data![index]['id'],
                                  avatar: homePageController.data![index]['picture_path'],
                                  name: homePageController.data![index]['name'],
                                ),
                                itemCount: homePageController.data!.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                  childAspectRatio: 0.8,
                                ),
                              ),
                            )
                          : const Center(
                              child: CustomText(
                                text: 'مخاطبی وجود ندارد',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ))
                      : const Center(child: LoadingIndicator()),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
