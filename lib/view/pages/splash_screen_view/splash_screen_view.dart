import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';

// splash view

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  bool _logoVisible = false;
  @override
  void initState() {
    super.initState();
    // Start small entrance animation then navigate.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _logoVisible = true);
      // keep splash visible for 1800ms then navigate
      Future.delayed(const Duration(milliseconds: 1800), handleNavigation);
    });
  }

  Future<void> handleNavigation() async {
    final token = pref.read("userToken");
    // small safety delay already applied; route based on stored token
    if (token != null && token.toString().isNotEmpty) {
      Get.offAllNamed(RouteName.home);
    } else {
      Get.offAllNamed(RouteName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with subtle dark overlay
          Image.asset('assets/images/Untitled design.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.38)),

          // Center card with logo and loader
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: _logoVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.28),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 180,
                                height: 90,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Kalapi Farsan',
                                style: GoogleFonts.mulish(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Trusted name for quality',
                                style: GoogleFonts.mulish(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
