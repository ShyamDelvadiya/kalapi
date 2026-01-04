import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kalapi/bindings/app_controller.dart';
import 'package:kalapi/routing/route_binding.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/theme_controller/theme_controller.dart';
import 'Bindings/app_binding.dart';
import 'package:flutter/gestures.dart';

var pref = GetStorage();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure GetStorage is fully initialized before using `pref`.
  // SafeGoogleFonts performs lazy detection; do not probe AssetManifest here.
  await GetStorage.init();
  Get.put(AppController());
  runApp(MyApp());
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Remove the glow effect on all scrollables
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
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
              scrollBehavior: const NoGlowScrollBehavior(),
              themeMode: themeController.themeMode.value,
              theme: ThemeData.light().copyWith(
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
              ),
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
