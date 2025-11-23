import 'package:get/get.dart';

import '../modules/root/root_bindings.dart';
import '../modules/root/root_page.dart';

part 'app_routes.dart';

class AppPages {
  const AppPages._();

  static const initial = Routes.root;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.root,
      page: () => const RootPage(),
      binding: RootBindings(),
    ),
  ];
}
