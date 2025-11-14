import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';

// splash view

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNavigation();
    });
  }

  Future<void> handleNavigation() async {
    final token = pref.read("userToken");
    print(" Splash Screen Token: $token ");
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(RouteName.home);
    } else {
      Get.offAllNamed(RouteName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text('Farshan', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
