import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveStorage {
  static saveTheme({required Color color}) async {
    Box box = await Hive.openBox("theme");
    await box.put("theme_color", color.value);
    await box.close();
  }

  static Future<int> restoreTheme() async {
    Box box = await Hive.openBox("theme");
    int? colorValue = await box.get("theme_color");
    await box.close();
    return colorValue ?? const Color(0xff9610fe).value;
  }
}
