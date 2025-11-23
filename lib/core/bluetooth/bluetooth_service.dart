import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';

import '../utils/logger.dart';
import 'bluetooth_exception.dart';

class BluetoothService {
  BluetoothService(this._bluetooth);

  final FlutterBluetoothSerial _bluetooth;

  BluetoothConnection? _connection;
  StreamSubscription<Uint8List>? _inputSubscription;
  final StreamController<Uint8List> _rawController = StreamController<Uint8List>.broadcast();
  final StreamController<bool> _connectionStateController = StreamController<bool>.broadcast();

  Stream<Uint8List> get rawStream => _rawController.stream;
  Stream<bool> get connectionState => _connectionStateController.stream;
  bool get isConnected => _connection?.isConnected ?? false;

  Future<List<BluetoothDevice>> bondedDevices() async {
    await _ensureEnabled();
    try {
      final devices = await _bluetooth.getBondedDevices();
      AppLogger.d('BT', 'Bonded devices found: ${devices.length}');
      return devices;
    } catch (e) {
      AppLogger.d('BT', 'Failed to fetch bonded devices: $e');
      throw BluetoothFailure('Could not list bonded devices');
    }
  }

  Future<void> connect(String address) async {
    AppLogger.d('BT', 'Connecting...');
    await _ensureEnabled();
    await disconnect();
    try {
      _connection = await BluetoothConnection.toAddress(address);
      AppLogger.d('BT', 'Connected');
      _connectionStateController.add(true);
      _listenToInput();
    } catch (e) {
      AppLogger.d('BT', 'Connection error: $e');
      throw BluetoothFailure('Failed to connect to $address');
    }
  }

  Future<void> disconnect() async {
    if (_inputSubscription != null) {
      await _inputSubscription?.cancel();
      _inputSubscription = null;
    }
    if (_connection != null) {
      await _connection?.finish();
      _connection = null;
      AppLogger.d('BT', 'Disconnected');
    }
    _connectionStateController.add(false);
  }

  void _listenToInput() {
    final input = _connection?.input;
    if (input == null) {
      AppLogger.d('BT', 'No input stream available');
      return;
    }

    _inputSubscription = input.listen(
      (data) {
        // Pass-through raw data for parser; log here for traceability.
        _rawController.add(data);
      },
      onDone: () {
        AppLogger.d('BT', 'Input stream closed');
        disconnect();
      },
      onError: (error) {
        AppLogger.d('BT', 'Input error: $error');
      },
      cancelOnError: true,
    );
  }

  void dispose() {
    _rawController.close();
    _connectionStateController.close();
    disconnect();
  }

  Future<void> _ensureEnabled() async {
    final enabled = await _bluetooth.isEnabled;
    if (enabled == false) {
      AppLogger.d('BT', 'Requesting to enable adapter');
      await _bluetooth.requestEnable();
    }
  }
}
