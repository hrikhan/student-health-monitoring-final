import 'dart:convert';
import 'dart:typed_data';

import '../utils/logger.dart';
import '../utils/validators.dart';

class BluetoothParser {
  Stream<int> parseBpm(Stream<Uint8List> rawStream) async* {
    final buffer = StringBuffer();
    await for (final chunk in rawStream) {
      final decoded = utf8.decode(chunk, allowMalformed: true);
      AppLogger.d('BT RAW', decoded);
      buffer.write(decoded);

      String content = buffer.toString();
      final lines = content.split('\n');

      // Keep last partial line in buffer.
      buffer
        ..clear()
        ..write(lines.removeLast());

      for (final rawLine in lines) {
        final line = rawLine.trim();
        if (line.isEmpty) continue;
        AppLogger.d('BT LINE', line);
        final bpm = int.tryParse(line);
        if (bpm == null) {
          AppLogger.d('PARSE', 'Could not parse line: $line');
          continue;
        }
        if (!Validators.isValidBpm(bpm)) {
          AppLogger.d('PARSE', 'Invalid BPM discarded: $bpm');
          continue;
        }
        AppLogger.d('BT BPM', bpm.toString());
        yield bpm;
      }
    }
  }
}
