import 'package:get/get.dart';

import '../../../core/utils/logger.dart';
import 'heartbeat_controller.dart';

extension HeartbeatControllerActions on HeartbeatController {
  Future<void> clearHistorySafe() async {
    try {
      history.clear();
      await storageService.saveHistory(history);
      AppLogger.d('HISTORY', 'Cleared history');
      currentPulse.value = 0;
    } catch (e) {
      AppLogger.d('HISTORY', 'Failed to clear: $e');
      rethrow;
    }
  }
}
