import 'dart:async';

import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:get/get.dart';

import '../../../core/bluetooth/bluetooth_parser.dart';
import '../../../core/bluetooth/bluetooth_service.dart';
import '../../../core/storage/pulse_history_model.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/logger.dart';

class HeartbeatController extends GetxController {
  HeartbeatController({
    required this.bluetoothService,
    required this.parser,
    required this.storageService,
  });

  final BluetoothService bluetoothService;
  final BluetoothParser parser;
  final StorageService storageService;

  final RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;
  final Rxn<BluetoothDevice> selectedDevice = Rxn<BluetoothDevice>();
  final RxnInt currentPulse = RxnInt();
  final RxBool isConnecting = false.obs;
  final RxBool isConnected = false.obs;
  final RxList<PulseHistoryModel> history = <PulseHistoryModel>[].obs;
  final RxString status = 'Disconnected'.obs;

  StreamSubscription<int>? _bpmSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToBpm();
    _listenToConnection();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await loadHistory();
    await loadBondedDevices();
  }

  Future<void> loadBondedDevices() async {
    final bonded = await bluetoothService.bondedDevices();
    devices.assignAll(bonded);
    if (bonded.isNotEmpty) {
      selectedDevice.value = bonded.first;
    }
  }

  Future<void> connect() async {
    final device = selectedDevice.value;
    if (device == null) return;
    isConnecting.value = true;
    status.value = 'Connecting to ${device.name ?? device.address}';
    try {
      await bluetoothService.connect(device.address);
      isConnected.value = true;
      status.value = 'Connected to ${device.name ?? device.address}';
    } catch (e) {
      status.value = 'Connection failed';
      AppLogger.d('BT', 'Connect error: $e');
    } finally {
      isConnecting.value = false;
    }
  }

  Future<void> disconnect() async {
    await bluetoothService.disconnect();
    isConnected.value = false;
    status.value = 'Disconnected';
  }

  void _listenToBpm() {
    _bpmSubscription = parser.parseBpm(bluetoothService.rawStream).listen(
      (bpm) {
        currentPulse.value = bpm;
        _addHistory(bpm);
      },
      onError: (err) => AppLogger.d('PARSE', 'Stream error: $err'),
    );
  }

  void _listenToConnection() {
    _connectionSubscription = bluetoothService.connectionState.listen((connected) {
      isConnected.value = connected;
      if (!connected) {
        status.value = 'Disconnected';
      }
    });
  }

  Future<void> _addHistory(int bpm) async {
    final entry = PulseHistoryModel(bpm: bpm, timestamp: DateTime.now());
    history.insert(0, entry);
    // Keep latest 50 readings to avoid unbounded growth.
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    await storageService.saveHistory(history);
  }

  Future<void> loadHistory() async {
    final loaded = await storageService.loadHistory();
    history.assignAll(loaded);
  }

  @override
  void onClose() {
    _bpmSubscription?.cancel();
    _connectionSubscription?.cancel();
    bluetoothService.dispose();
    super.onClose();
  }
}
