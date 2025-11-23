import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:get/get.dart';

import '../controllers/heartbeat_controller.dart';
import '../widgets/pulse_display.dart';

class HeartbeatPage extends GetView<HeartbeatController> {
  const HeartbeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadBondedDevices,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => DropdownButton<BluetoothDevice>(
                isExpanded: true,
                hint: const Text('Select device'),
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
                  ElevatedButton.icon(
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
                    label: const Text('Connect'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: controller.isConnected.value ? controller.disconnect : null,
                    icon: const Icon(Icons.bluetooth_disabled),
                    label: const Text('Disconnect'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Text('Status: ${controller.status.value}')),
            const SizedBox(height: 12),
            Obx(
              () => PulseDisplay(
                bpm: controller.currentPulse.value,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'History',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.history.length,
                  itemBuilder: (_, index) {
                    final item = controller.history[index];
                    return ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text('${item.bpm} BPM'),
                      subtitle: Text(item.timestamp.toLocal().toString()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
