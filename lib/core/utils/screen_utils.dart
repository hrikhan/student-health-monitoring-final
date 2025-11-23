import 'package:flutter/widgets.dart';

class ScreenUtils {
  const ScreenUtils._();

  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  static double responsiveFont(BuildContext context, {required double base, double min = 12, double max = 72}) {
    final w = width(context);
    final scale = (w / 390).clamp(0.75, 1.1);
    final value = base * scale;
    return value.clamp(min, max);
  }
}
