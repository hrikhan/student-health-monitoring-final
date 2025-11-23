import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void switchTab(int index) {
    currentIndex.value = index;
  }

  void switchToEnglish() {
    Get.updateLocale(const Locale('en', 'US'));
  }

  void switchToBangla() {
    Get.updateLocale(const Locale('bn', 'BD'));
  }
}
