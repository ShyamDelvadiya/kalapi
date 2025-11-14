import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_pg/bindings/app_controller.dart';
import 'package:my_pg/routing/route_binding.dart';
import 'package:my_pg/routing/route_name.dart';
import 'package:my_pg/theme_controller/theme_controller.dart';
import 'Bindings/app_binding.dart';

var pref = GetStorage();
Timer? delaySearchTimer;
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  Get.put(AppController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(360.0, 690.0),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: GetMaterialApp(
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              navigatorObservers: [routeObserver],
              themeMode: themeController.themeMode.value,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              smartManagement: SmartManagement.full,
              initialBinding: AppBinding(),
              initialRoute: RouteName.splash,
              getPages: Routes.pages,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }
}
