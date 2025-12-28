import 'package:get/get.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/view/pages/home/home_view.dart';
import 'package:kalapi/view/pages/login/view/login_view.dart';
import 'package:kalapi/view/pages/splash_screen_view/splash_screen_view.dart';
import 'package:kalapi/view/pages/legal/legal_view.dart';

class Routes {
  static List<GetPage> pages = [
    GetPage(name: RouteName.splash, page: () => SplashScreenView()),
    GetPage(name: RouteName.login, page: () => LoginView()),
    GetPage(name: RouteName.home, page: () => HomeView()),
    GetPage(name: RouteName.legal, page: () => LegalView()),
  ];
}
