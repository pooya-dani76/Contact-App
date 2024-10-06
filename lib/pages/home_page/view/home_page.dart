import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/contact_card.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

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
              builder: (homePageController) => CustomAppBar(
                    title: 'مخاطبین',
                    searchMode: homePageController.searchMode,
                    onCloseSearchButtonTap: onCloseSearchButtonTap,
                    onSearchWordChange: ()=> homePageController.search(),
                    searchController: homePageController.searchController,
                    onSearchButtonTap: () => homePageController.setSearchMode(true),
                  )),
          const SizedBox(height: 30),
          Expanded(
            child: GetBuilder<HomePageController>(builder: (homePageController) {
              if (homePageController.data != null) {
                if (homePageController.data!.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'مخاطبی ذخیره نشده است',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => ContactCard(
                      contactId: homePageController.data![index]['id'],
                      avatar: homePageController.data![index]['pic_path'],
                      name: homePageController.data![index]['name'].toString(),
                    ),
                    itemCount: homePageController.data!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 0.8,
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ],
      ),
    );
  }
}
