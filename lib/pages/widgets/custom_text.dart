import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLine,
    this.textDirection = TextDirection.rtl,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLine;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection!,
      child: AutoSizeText(
        text.toString().tr,
        maxFontSize: 25,
        minFontSize: 12,
        textScaleFactor: 1,
        maxLines: maxLine,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: "Vazir",
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
