import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';

// ignore: must_be_immutable
class CustomPhoneInputField extends StatelessWidget {
  CustomPhoneInputField(
      {super.key,
      required this.controller,
      this.onCountryChanged,
      required this.initCountryCode,
      required this.controllerIndex});

  final TextEditingController controller;
  final void Function(Country)? onCountryChanged;
  final String initCountryCode;
  final int controllerIndex;

  EditPageController editPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      onCountryChanged: onCountryChanged,
      initialCountryCode: initCountryCode,
      invalidNumberMessage: 'شماره وارد شده معتبر نیست',
      textAlignVertical: TextAlignVertical.center,
      onChanged: (newValue) {
        try {
          editPageController.numberControllers[controllerIndex]['is_valid'] =  newValue.isValidNumber();
        } catch (e) {
          editPageController.numberControllers[controllerIndex]['is_valid'] = false;
        }
      },
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
