import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      // keep splash visible for 2000ms then navigate
      Future.delayed(const Duration(milliseconds: 2000), handleNavigation);
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
          // Background image with warm overlay
          Image.asset(
            'assets/images/Untitled design.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),

          // Warm gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6F00).withOpacity(0.4), // Amber 900
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

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
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutBack,
                          transform: Matrix4.translationValues(
                            0,
                            _logoVisible ? 0 : 50,
                            0,
                          ),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD84315),
                                Color(0xFFFF6F00),
                              ], // Deep Orange to Amber
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 15),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/logo 1.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Kalapi Farsan',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Taste the Tradition',
                                style: GoogleFonts.outfit(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
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
