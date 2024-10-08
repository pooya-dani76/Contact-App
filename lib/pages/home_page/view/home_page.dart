import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/contact_card.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';
import 'package:special_phone_book/routes/routes.dart';

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
                            onChanged: (value) => Future.delayed(
                              const Duration(milliseconds: 500),
                              () => homePageController.search(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomAppBar(
                    title: 'مخاطبین',
                    leading: [
                      CustomButton(
                        onTap: () => routeToPage(page: Routes.editPage),
                        color: Colors.blue,
                        maxSize: const Size(35, 35),
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onTap: () => homePageController.setSearchMode(true),
                        color: Colors.greenAccent[400],
                        maxSize: const Size(35, 35),
                        child: const Icon(Icons.search_rounded),
                      ),
                    ],
                    trailing: const [
                      Spacer(),
                      Avatar(
                        image: '',
                        maxSize: Size(35, 35),
                      ),
                    ],
                  ),
          ),
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
