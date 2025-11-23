import 'package:get/get.dart';

import '../modules/heartbeat/heartbeat_bindings.dart';
import '../modules/heartbeat/views/heartbeat_page.dart';

part 'app_routes.dart';

class AppPages {
  const AppPages._();

  static const initial = Routes.heartbeat;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.heartbeat,
      page: () => const HeartbeatPage(),
      binding: HeartbeatBindings(),
    ),
  ];
}
