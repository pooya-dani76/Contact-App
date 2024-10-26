import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.image,
    this.maxSize,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
  });

  final String image;
  final Size? maxSize;
  final double? borderRadius;
  final BoxShape? boxShape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: boxShape == BoxShape.rectangle
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            )
          : const CircleBorder(),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:  boxShape == BoxShape.rectangle
          ? BorderRadius.circular(borderRadius ?? 12) : null,
          shape: boxShape!,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: image.isNotEmpty
                ? FileImage(File(image))
                : const AssetImage('assets/images/unknown_person.png'),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: maxSize != null ? maxSize!.height : double.infinity,
          maxWidth: maxSize != null ? maxSize!.width : double.infinity,
        ),
      ),
    );
  }
}
