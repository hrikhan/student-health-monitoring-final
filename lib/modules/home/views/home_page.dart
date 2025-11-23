import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:get/get.dart';

import '../../heartbeat/controllers/heartbeat_controller.dart';
import '../../home/widgets/bpm_card.dart';
import '../../home/widgets/heartbeat_wave.dart';

class HomePage extends GetView<HeartbeatController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => DropdownButtonFormField<BluetoothDevice>(
              decoration: InputDecoration(
                labelText: 'Select device',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              isExpanded: true,
              value: controller.selectedDevice.value,
              items: controller.devices
                  .map(
                    (device) => DropdownMenuItem(
                      value: device,
                      child: Text('${device.name ?? 'Unknown'} (${device.address})'),
                    ),
                  )
                  .toList(),
              onChanged: controller.isConnecting.value
                  ? null
                  : (device) => controller.selectedDevice.value = device,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: controller.isConnected.value
                          ? Colors.greenAccent.withOpacity(0.2)
                          : const Color(0xFF0DE47B),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: controller.isConnecting.value || controller.isConnected.value
                        ? null
                        : controller.connect,
                    icon: controller.isConnecting.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.bluetooth_connected),
                    label: Text(
                      controller.isConnected.value ? 'connected'.tr : 'Connect',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(
                        color: controller.isConnected.value ? Colors.redAccent : Colors.grey,
                        width: 1.5,
                      ),
                      foregroundColor: controller.isConnected.value ? Colors.redAccent : Colors.grey,
                    ),
                    onPressed: controller.isConnected.value ? controller.disconnect : null,
                    icon: const Icon(Icons.bluetooth_disabled),
                    label: Text(
                      'disconnected'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Obx(
                () => HeartbeatWave(bpm: controller.currentPulse.value),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'current_bpm'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const SweepGradient(
                  colors: [
                    Color(0xFF0DE47B),
                    Color(0xFF0BAF6C),
                    Color(0xFF0DE47B),
                  ],
                  stops: [0.0, 0.5, 1.0],
                  center: Alignment.topLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0DE47B).withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: BpmCard(
                bpm: controller.currentPulse.value,
                isConnected: controller.isConnected.value,
                statusText: controller.isConnected.value ? 'connected'.tr : 'disconnected'.tr,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              children: [
                Icon(
                  controller.isConnected.value ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                  color: controller.isConnected.value ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text('status'.tr),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.status.value,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
