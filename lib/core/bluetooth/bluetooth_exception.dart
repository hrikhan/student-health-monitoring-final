class BluetoothFailure implements Exception {
  BluetoothFailure(this.message);

  final String message;

  @override
  String toString() => 'BluetoothFailure: $message';
}
