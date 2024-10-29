import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:special_phone_book/pages/widgets/address_tile.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class AddressesShow extends StatelessWidget {
  const AddressesShow({super.key, required this.addresses});

  final List addresses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomText(
          text: 'آدرس‌ها',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        const SizedBox(height: 20),
        if (addresses.isNotEmpty) ...{
          GridView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => AddressTile(
              isEditing: false,
              coordinateIndex: index,
              coordinate: LatLng(addresses[index]['latitude'], addresses[index]['longitude']),
            ),
            itemCount: addresses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
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
        } else ...{
          const Center(
            child: CustomText(
              text: 'آدرسی ثبت نشده است',
              color: Colors.grey,
            ),
          )
        }
      ],
    );
  }
}
