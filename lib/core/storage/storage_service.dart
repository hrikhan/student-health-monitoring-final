import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';
import 'pulse_history_model.dart';
import 'storage_keys.dart';

class StorageService {
  Future<List<PulseHistoryModel>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(StorageKeys.pulseHistory) ?? [];
    final history = raw
        .map((e) => PulseHistoryModel.fromMap(jsonDecode(e) as Map<String, dynamic>))
        .toList();
    AppLogger.d('HISTORY', 'Loaded ${history.length} items');
    return history;
  }

  Future<void> saveHistory(List<PulseHistoryModel> history) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = history.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(StorageKeys.pulseHistory, payload);
    AppLogger.d('HISTORY', 'Saved ${history.length} items');
  }
}
