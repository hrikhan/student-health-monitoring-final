import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/translations/app_translations.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(const HealthMonitoringApp());
}

class HealthMonitoringApp extends StatelessWidget {
  const HealthMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Monitoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0DE47B),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A1413),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF0E1C1B),
          indicatorColor: Color(0x3300FF9D),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E1C1B),
        ),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
