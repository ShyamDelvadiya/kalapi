import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_pg/utils/color_resources.dart';
import 'package:my_pg/utils/diamension.dart';
import 'package:my_pg/view/basewidget/textformfield/custom_text_form_field.dart';
import 'package:my_pg/view/basewidget/custom_button/custom_button.dart';
import 'package:my_pg/view/pages/login/controller/loginController.dart';
import 'package:my_pg/routing/route_name.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _buildCard(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo / Title
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColorOwner(context),
                  ),
                  child: const Icon(Icons.lock_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.mulish(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sign in to continue',
                        style: GoogleFonts.mulish(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            height(h20),
            // Email
            CustomTextFormField(
              controller: _emailCtrl,
              hintText: 'Email',
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixImage: const Icon(Icons.alternate_email_rounded),
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
              prefixImage: const Icon(Icons.lock_outline_rounded),
              suffixImage: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
              ),
              validator:
                  (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
            ),

            height(h20),

            // Login button
            Obx(() {
              final loading = controller.isLoading.value;
              return CustomButton(
                height: 48,
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

            // Divider with text
          ],
        ),
      ),
    );
  }
}
