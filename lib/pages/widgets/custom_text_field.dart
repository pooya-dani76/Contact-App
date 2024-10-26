import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.maxLines,
    this.maxLength,
    this.label,
    this.cursorColor,
    this.inputDecoration,
    this.onChanged,
    this.autofocus = false,
    this.hint,
    this.prefixIcon,
    this.prefixWidget,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.suffixWidget,
    this.textDirection = TextDirection.rtl,
  });

  final TextEditingController controller;
  final int? maxLines;
  final int? maxLength;
  final String? label;
  final String? hint;
  final Color? cursorColor;
  final InputDecoration? inputDecoration;
  final Function(String)? onChanged;
  final bool? autofocus;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode focus = FocusNode();
  late bool focused;

  @override
  void initState() {
    super.initState();
    focus.addListener(onFocusChange);
    focused = false;
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(onFocusChange);
    focus.dispose();
  }

  void onFocusChange() {
    setState(() {
      focused = focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...{
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomText(
                text: widget.label!,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
          },
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: Color(0xFF6FB4AB),
                width: 1.5,
              ),
            ),
            child: TextField(
              focusNode: focus,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              textInputAction: TextInputAction.done,
              inputFormatters: widget.inputFormatters,
              controller: widget.controller,
              autofocus: widget.autofocus!,
              style: const TextStyle(fontFamily: "Vazir"),
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colors.grey[300]),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF6FB4AB),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: widget.prefixWidget ??
                    (widget.prefixIcon != null
                        ? Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6FB4AB),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.prefixIcon!,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        : null),
                suffixIcon: widget.suffixWidget ??
                    (widget.suffixIcon != null
                        ? Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6FB4AB),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.suffixIcon!,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        : null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
