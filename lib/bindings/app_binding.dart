
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../theme_controller/theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
