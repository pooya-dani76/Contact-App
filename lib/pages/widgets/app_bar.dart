import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/pages/widgets/custom_text_field.dart';
import 'package:special_phone_book/routes/routes.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.homePageMode = true,
    required this.title,
    required this.searchMode,
    this.onSearchButtonTap,
    this.onCloseSearchButtonTap,
    this.onAddTap,
    this.searchController,
    this.onSearchWordChange,
  });

  final bool? homePageMode;
  final String title;
  final bool searchMode;
  final VoidCallback? onSearchButtonTap;
  final VoidCallback? onCloseSearchButtonTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onSearchWordChange;
  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
      height: 80,
      child: searchMode
          ? Row(
              children: [
                CustomButton(
                  onTap: () {
                    if (onCloseSearchButtonTap != null) {
                      onCloseSearchButtonTap!();
                    }
                  },
                  color: Colors.red,
                  maxSize: const Size(35, 35),
                  child: const Icon(Icons.close_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: searchController ?? TextEditingController(),
                    maxLines: 1,
                    onChanged: (value) => Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        if (searchController!.text == value) {
                          onSearchWordChange!();
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (homePageMode!) ...{
                        CustomButton(
                          onTap: () {
                            if (onAddTap != null) {
                              onAddTap!();
                            }
                            routeToPage(page: Routes.detailPage);
                          },
                          color: Colors.blue,
                          maxSize: const Size(35, 35),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          onTap: () {
                            if (onSearchButtonTap != null) {
                              onSearchButtonTap!();
                            }
                          },
                          color: Colors.greenAccent[400],
                          maxSize: const Size(35, 35),
                          child: const Icon(Icons.search_rounded),
                        ),
                      } else ...{
                        Container(width: 80)
                      }
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CustomText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (homePageMode!) ...{
                        const Spacer(),
                        const Avatar(
                          image: '',
                          maxSize: Size(35, 35),
                        ),
                      } else ...{
                        const Spacer(),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Directionality(
                              textDirection: TextDirection.ltr, child: Icon(CupertinoIcons.back)),
                        )
                      },
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
