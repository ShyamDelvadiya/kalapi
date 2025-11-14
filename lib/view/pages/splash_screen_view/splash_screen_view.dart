import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_pg/view/pages/splash_screen_view/controller/splash_controller.dart';
// splash view

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final splashImage = 'assets/images/lightSplashScreen.png';
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
            // logo if svg present
            if (true) ...[
              SizedBox(
                width: 140,
                height: 140,
                child: Image.asset(splashImage, fit: BoxFit.contain),
              ),
              const SizedBox(height: 24),
            ],
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text('Farshan', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
