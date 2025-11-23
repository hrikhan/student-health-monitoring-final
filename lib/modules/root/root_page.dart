import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../heartbeat/controllers/heartbeat_controller.dart';
import '../heartbeat/controllers/heartbeat_controller_extensions.dart';
import '../home/views/home_page.dart';
import '../history/views/history_page.dart';
import '../students/views/student_list_page.dart';
import 'root_controller.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});

  Future<void> _confirmClearHistory(BuildContext context, HeartbeatController hb) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('confirm_clear_title'.tr),
        content: Text('confirm_clear_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('no'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('yes'.tr),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      await hb.clearHistorySafe();
      Get.snackbar('history'.tr, 'cleared'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heartbeat = Get.find<HeartbeatController>();
    final pages = [
      const HomePage(),
      const HistoryPage(),
      StudentListPage(),
    ];

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('app_title'.tr),
          actions: [
            IconButton(
              tooltip: 'refresh',
              icon: const Icon(Icons.refresh),
              onPressed: heartbeat.loadBondedDevices,
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('language'.tr),
                ),
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: Text('english'.tr),
                  onTap: () => controller.switchToEnglish(),
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text('bangla'.tr),
                  onTap: () => controller.switchToBangla(),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text('clear_history'.tr),
                  onTap: () => _confirmClearHistory(context, heartbeat),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Health Monitoring\nVersion 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: pages[controller.currentIndex.value],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: const Color(0xCC12332D),
                child: NavigationBar(
                  height: 70,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  selectedIndex: controller.currentIndex.value,
                  onDestinationSelected: controller.switchTab,
                  backgroundColor: Colors.transparent,
                  indicatorColor: const Color(0x3300FF9D),
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home_rounded),
                      label: 'nav_home'.tr,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.show_chart_outlined),
                      selectedIcon: const Icon(Icons.show_chart_rounded),
                      label: 'nav_history'.tr,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.people_outline),
                      selectedIcon: const Icon(Icons.people_rounded),
                      label: 'nav_students'.tr,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
