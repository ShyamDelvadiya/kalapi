import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/utils/diamension.dart';
import 'package:kalapi/view/basewidget/custom_button/custom_button.dart';
import 'package:kalapi/view/basewidget/textformfield/custom_text_form_field.dart';
import 'package:kalapi/view/pages/login/controller/loginController.dart';
import 'package:kalapi/view/basewidget/policy_links.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/login_bg.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(
              0.3,
            ), // Darken slightly for text contrast
            colorBlendMode: BlendMode.darken,
          ),

          // Gradient overlay for warmth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColorStudent(context).withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: _buildCard(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.whiteColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.whiteColor(context).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor(context),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColorStudent(
                                context,
                              ).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo 1.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Kalapi Farsan',
                        style: GoogleFonts.outfit(
                          // Changed to Outfit for premium look
                          fontSize: 28,
                          color: AppColors.whiteColor(context),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Taste the Tradition',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.whiteColor(context).withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                height(h30),

                // Email Field
                CustomTextFormField(
                  controller: _emailCtrl,
                  hintText: 'Email Address',
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixImage: Icon(
                    Icons.email_outlined,
                    color: AppColors.whiteColor(context).withOpacity(0.7),
                  ),
                  fillColor: AppColors.whiteColor(context).withOpacity(0.1),
                  hintstyle: GoogleFonts.outfit(
                    fontSize: 15,
                    color: AppColors.whiteColor(context).withOpacity(0.6),
                  ),
                  textStyle: GoogleFonts.outfit(
                    color: AppColors.whiteColor(context),
                    fontSize: 16,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your email';
                    if (!GetUtils.isEmail(v)) return 'Invalid email address';
                    return null;
                  },
                ),

                height(h16),

                // Password Field
                CustomTextFormField(
                  controller: _passCtrl,
                  hintText: 'Password',
                  obscureText: _obscure,
                  prefixImage: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.whiteColor(context).withOpacity(0.7),
                  ),
                  suffixImage: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.whiteColor(context).withOpacity(0.7),
                    ),
                  ),
                  fillColor: AppColors.whiteColor(context).withOpacity(0.1),
                  hintstyle: GoogleFonts.outfit(
                    fontSize: 15,
                    color: AppColors.whiteColor(context).withOpacity(0.6),
                  ),
                  textStyle: GoogleFonts.outfit(
                    color: AppColors.whiteColor(context),
                    fontSize: 16,
                  ),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? 'Please enter your password'
                              : null,
                ),

                height(h30),

                // Login Button
                Obx(() {
                  final loading = controller.isLoading.value;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColorStudent(
                            context,
                          ).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      height: 56,
                      text: 'Sign In',
                      isLoading: loading,
                      textcolor: Colors.white,
                      fontsize: 18,
                      color: AppColors.primaryColorStudent(context),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          controller.loginApiCall(
                            email: _emailCtrl.text.trim(),
                            password: _passCtrl.text,
                            onSuccess: () => Get.offAllNamed(RouteName.home),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                // Privacy Policy and Terms
                PolicyLinksRow(
                  textColor: AppColors.whiteColor(context).withOpacity(0.9),
                  alignment: MainAxisAlignment.center,
                  underline: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
