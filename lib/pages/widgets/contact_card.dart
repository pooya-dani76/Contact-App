import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';
import 'package:special_phone_book/routes/routes.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.contactId,
  });

  final String? avatar;
  final String name;
  final int contactId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => routeToPage(
        page: Routes.detailPage,
        arguments: {'id': contactId},
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Avatar(
              image: avatar ?? '',
              borderRadius: 15,
            )),
            const SizedBox(height: 10),
            CustomText(
              text: name,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
