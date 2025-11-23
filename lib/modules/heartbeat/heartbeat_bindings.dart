import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:get/get.dart';

import '../../core/bluetooth/bluetooth_parser.dart';
import '../../core/bluetooth/bluetooth_service.dart';
import '../../core/storage/storage_service.dart';
import 'controllers/heartbeat_controller.dart';

class HeartbeatBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BluetoothService>(() => BluetoothService(FlutterBluetoothSerial.instance));
    Get.lazyPut<BluetoothParser>(() => BluetoothParser());
    Get.lazyPut<StorageService>(() => StorageService());
    Get.lazyPut<HeartbeatController>(() => HeartbeatController(
          bluetoothService: Get.find(),
          parser: Get.find(),
          storageService: Get.find(),
        ));
  }
}
