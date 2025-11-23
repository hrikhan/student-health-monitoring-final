import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../heartbeat/controllers/heartbeat_controller.dart';
import '../../heartbeat/controllers/heartbeat_controller_extensions.dart';
import '../widgets/history_chart.dart';

class HistoryPage extends GetView<HeartbeatController> {
  const HistoryPage({super.key});

  Future<void> _confirmClear(BuildContext context) async {
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
      await controller.clearHistorySafe();
      Get.snackbar('history'.tr, 'cleared'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('history'.tr, style: Theme.of(context).textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => _confirmClear(context),
                icon: const Icon(Icons.delete_outline),
                label: Text('clear_history'.tr),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () {
              final data = controller.history.toList();
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: SizedBox(
                  height: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: HistoryChart(history: data),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text('history'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(
              () {
                if (controller.history.isEmpty) {
                  return Center(child: Text('no_history'.tr));
                }
                return ListView.builder(
                  itemCount: controller.history.length,
                  itemBuilder: (_, index) {
                    final item = controller.history[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.redAccent),
                        title: Text('${item.bpm} BPM'),
                        subtitle: Text(item.timestamp.toLocal().toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
