import 'package:get/get.dart';

import '../heartbeat/heartbeat_bindings.dart';
import 'root_controller.dart';

class RootBindings extends Bindings {
  @override
  void dependencies() {
    HeartbeatBindings().dependencies();
    Get.lazyPut<RootController>(() => RootController());
  }
}
