import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  late ThemeMode tempSelectedTheme;
  final prefs = GetStorage();
  @override
  void onInit() {
    super.onInit();
    var savedTheme = prefs.read('themeMode');
    ThemeMode mode =
        ThemeMode
            .light; // Default to light to show light theme when no stored preference exists
    if (savedTheme != null) {
      try {
        final int idx =
            savedTheme is int ? savedTheme : int.parse(savedTheme.toString());
        if (idx >= 0 && idx < ThemeMode.values.length) {
          mode = ThemeMode.values[idx];
        }
      } catch (_) {
        // ignore and fall back to light
      }
    }
    themeMode.value = mode;
  }

  void setSelectedTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    prefs.write('themeMode', mode.index);
  }
}
