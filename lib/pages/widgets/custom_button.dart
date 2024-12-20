// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.child,
    this.maxSize,
    this.borderRadius, this.isFlat = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final Size? maxSize;
  final double? borderRadius;
  final bool? isFlat;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isFlat! ? 0 : 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 12)),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            shape: BoxShape.rectangle,
          ),
          constraints: BoxConstraints(
            maxHeight: maxSize != null ? maxSize!.height : double.infinity,
            maxWidth: maxSize != null ? maxSize!.width : double.infinity,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
