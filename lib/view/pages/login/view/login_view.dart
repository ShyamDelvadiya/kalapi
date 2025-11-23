import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:kalapi/routing/route_name.dart';
// import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/utils/diamension.dart';
import 'package:kalapi/view/basewidget/custom_button/custom_button.dart';
import 'package:kalapi/view/basewidget/textformfield/custom_text_form_field.dart';
import 'package:kalapi/view/pages/login/controller/loginController.dart';

// A simple email/password login form that uses LoginController

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
  bool _remember = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/Untitled design (1).png',
            fit: BoxFit.cover,
          ),
          // subtle gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.15),
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
                  constraints: const BoxConstraints(maxWidth: 520),
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
    // final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // header with logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                        child: Image.asset(
                          'assets/images/logo 1.png',
                          width: 140,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kalapi Farsan',
                        style: GoogleFonts.mulish(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Trusted name for quality',
                        style: GoogleFonts.mulish(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                height(h20),
                // Email
                CustomTextFormField(
                  controller: _emailCtrl,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixImage: const Icon(
                    Icons.alternate_email_rounded,
                    color: Colors.white70,
                  ),
                  fillColor: Colors.white.withOpacity(0.06),
                  hintstyle: GoogleFonts.mulish(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                  textStyle: const TextStyle(color: Colors.white),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter email';
                    return null;
                  },
                ),

                height(h14),

                // Password
                CustomTextFormField(
                  controller: _passCtrl,
                  hintText: 'Password',
                  obscureText: _obscure,
                  prefixImage: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white70,
                  ),
                  suffixImage: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.white70,
                    ),
                  ),
                  fillColor: Colors.white.withOpacity(0.06),
                  hintstyle: GoogleFonts.mulish(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                  textStyle: const TextStyle(color: Colors.white),
                  validator:
                      (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                ),
                height(h20),

                // Remember + forgot row
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            onChanged:
                                (v) => setState(() => _remember = v ?? false),
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Remember me',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot?',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),

                height(h14),

                // Login button
                Obx(() {
                  final loading = controller.isLoading.value;
                  return CustomButton(
                    height: 52,
                    text: 'Sign in',
                    isLoading: loading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.loginApiCall(
                          email: _emailCtrl.text.trim(),
                          password: _passCtrl.text,
                          onSuccess: () => Get.offAllNamed(RouteName.home),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                  );
                }),
              ],
            ), // Column
          ), // Form
        ), // Container
      ), // BackdropFilter
    ); // ClipRRect
  }
}
