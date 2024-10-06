import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.image,
    this.maxSize,
    this.borderRadius,
  });

  final String image;
  final Size? maxSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        shape: BoxShape.rectangle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(image.isNotEmpty ? image : 'assets/images/unknown_person.png'),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: maxSize != null ? maxSize!.height : double.infinity,
        maxWidth: maxSize != null ? maxSize!.width : double.infinity,
      ),
    );
  }
}
