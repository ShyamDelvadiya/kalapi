import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/basewidget/custom_app_bar/custom_app_bar.dart';
import 'package:kalapi/view/basewidget/custom_button/custom_button.dart';
import 'package:kalapi/view/basewidget/policy_links.dart';
import 'package:kalapi/view/basewidget/confirm_dialogs.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor(context),
      appBar: customAppBar(context, title: 'Legal & Account'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColorStudent(context),
                    AppColors.primaryColorOwner(context),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColorStudent(
                      context,
                    ).withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel_outlined, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Policies',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PolicyLinksRow(
                    alignment: MainAxisAlignment.start,
                    textColor: Colors.white,
                    underline: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Logout',
              height: 52,
              fontsize: 17,
              color: AppColors.primaryColorStudent(context),
              textcolor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              onPressed: () async {
                final confirm = await confirmLogoutDialog(context);
                if (confirm) {
                  try {
                    pref.erase();
                  } catch (_) {}
                  Get.offAllNamed(RouteName.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
