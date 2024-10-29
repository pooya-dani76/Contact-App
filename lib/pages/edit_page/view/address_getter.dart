import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';
import 'package:special_phone_book/pages/widgets/address_tile.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class AddressGetter extends StatelessWidget {
  const AddressGetter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPageController>(
      builder: (editPageController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomText(
              text: 'آدرس‌ها',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == editPageController.addresses.length) {
                  return InkWell(
                    onTap: editPageController.getAddress,
                    child: SizedBox(
                      child: DottedBorder(
                        radius: const Radius.circular(15),
                        borderType: BorderType.RRect,
                        color: const Color(0xff78c7bc),
                        child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_location_rounded,
                                    color: Color(0xff78c7bc),
                                    size: 30,
                                  ),
                                  SizedBox(height: 5),
                                  CustomText(
                                    text: 'افزودن آدرس',
                                    color: Color(0xff78c7bc),
                                    fontSize: 9,
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  );
                } else {
                  return AddressTile(
                    onCloseTap: () => editPageController.removeAddress(index: index),
                    isEditing: true,
                    coordinateIndex: index,
                    coordinate: LatLng(editPageController.addresses[index]['latitude'],
                        editPageController.addresses[index]['longitude']),
                  );
                }
              },
              itemCount: editPageController.addresses.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1,
              ),
            ),
            const SizedBox(height: 15),
          const CustomText(
          text: 'توجه: برای ثبت و یا مشاهده آدرس روی نقشه اینترنت شما باید روشن باشد',
          fontWeight: FontWeight.bold,
          color: Colors.red,
          maxLine: 2,
          fontSize: 10,
        ),
          ],
        );
      },
    );
  }
}
