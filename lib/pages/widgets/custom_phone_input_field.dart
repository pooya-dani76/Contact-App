import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneInputField extends StatelessWidget {
  const CustomPhoneInputField(
      {super.key, required this.controller, this.onCountryChanged, required this.initCountryCode});

  final TextEditingController controller;
  final void Function(Country)? onCountryChanged;
  final String initCountryCode;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      onCountryChanged: onCountryChanged,
      initialCountryCode: initCountryCode,
      invalidNumberMessage: 'شماره وارد شده معتبر نیست',
      textAlignVertical: TextAlignVertical.center,
      pickerDialogStyle: PickerDialogStyle(backgroundColor: const Color(0xffefedd4)),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF6FB4AB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.white,
        focusColor: const Color(0xFF6FB4AB),
      ),
    );
  }
}
