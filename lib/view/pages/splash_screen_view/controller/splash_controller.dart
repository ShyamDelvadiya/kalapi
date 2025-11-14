import 'package:get/get.dart';
import 'package:my_pg/main.dart';
import 'package:my_pg/routing/route_name.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    final bool = pref.read("isLoggedIn") ?? false;
    if (bool) {
      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed(RouteName.home);
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed(RouteName.login);
      });
    }

  }
}
