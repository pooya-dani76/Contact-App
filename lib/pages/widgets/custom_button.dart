// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    this.color,
    required this.child,
    this.maxSize,
    this.borderRadius,
  });

  final VoidCallback onTap;
  final Color? color;
  final Widget child;
  final Size? maxSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          shape: BoxShape.rectangle,
        ),
        constraints: BoxConstraints(
          maxHeight: maxSize != null ? maxSize!.height : double.infinity,
          maxWidth: maxSize != null ? maxSize!.width : double.infinity,
        ),
        child: Center(child: child),
      ),
    );
  }
}
