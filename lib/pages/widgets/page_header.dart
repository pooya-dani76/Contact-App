import 'package:flutter/material.dart';
import 'package:special_phone_book/pages/widgets/avatar.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class PageHeader extends StatelessWidget {
  const PageHeader(
      {super.key,
      this.onRightButtonTap,
      this.onLeftButtonTap,
      this.rightIcon,
      this.leftIcon,
      this.onAvatarTap,
      this.avatarShape = BoxShape.rectangle,
      this.name,
      this.picturePath,
      this.showName = true,
      this.onDeleteAvatarTap});

  final String? name;
  final String? picturePath;
  final VoidCallback? onRightButtonTap;
  final IconData? rightIcon;
  final VoidCallback? onLeftButtonTap;
  final IconData? leftIcon;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onDeleteAvatarTap;
  final BoxShape? avatarShape;
  final bool? showName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (onRightButtonTap != null) ...{
                CustomButton(
                  onTap: onRightButtonTap!,
                  maxSize: const Size(50, 50),
                  child: Icon(rightIcon),
                ),
              } else ...{
                const SizedBox(height: 55, width: 55)
              },
              InkWell(
                onTap: onAvatarTap,
                child: Badge(
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.topRight,
                  label: InkWell(
                      onTap: onDeleteAvatarTap,
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 18)),
                  isLabelVisible: onDeleteAvatarTap != null &&  picturePath != null,
                  child: Avatar(
                      image: picturePath ?? '',
                      maxSize: const Size(120, 120),
                      boxShape: avatarShape),
                ),
              ),
              if (onLeftButtonTap != null) ...{
                CustomButton(
                  onTap: onLeftButtonTap!,
                  maxSize: const Size(50, 50),
                  child: Icon(leftIcon),
                ),
              } else ...{
                const SizedBox(height: 55, width: 55)
              }
            ],
          ),
          if (showName!) ...{
            const SizedBox(height: 10),
            Center(
              child: CustomText(
                text: name!.isNotEmpty ? name! : 'بدون نام',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            )
          }
        ],
      ),
    );
  }
}
