import 'package:get/get.dart';
import 'package:my_pg/routing/route_name.dart';
import 'package:my_pg/view/pages/login/view/login_view.dart';
import 'package:my_pg/view/pages/splash_screen_view/splash_screen_view.dart';
import 'package:my_pg/view/pages/home/home_view.dart';

class Routes {
  static List<GetPage> pages = [
    GetPage(name: RouteName.splash, page: () => SplashScreenView()),
    GetPage(name: RouteName.login, page: () => LoginView()),
    GetPage(name: RouteName.home, page: () => HomeView()),
  ];
}
