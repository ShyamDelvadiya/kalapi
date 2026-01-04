import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/main.dart';
import 'package:kalapi/routing/route_name.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/basewidget/custom_button/custom_button.dart';
import 'package:kalapi/view/basewidget/policy_links.dart';
import 'package:kalapi/view/basewidget/confirm_dialogs.dart';
import 'package:kalapi/view/pages/home/controller/home_controller.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final branch = homeController.branchDetailsResponseModel.value;
    return Scaffold(
      backgroundColor: AppColors.backGroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColorStudent(context),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      Icon(Icons.store_outlined, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Branch Details',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow(context, 'Branch Name', branch.branchName ?? '-'),
                  const SizedBox(height: 10),
                  _infoRow(context, 'GST Number', branch.gstNumber ?? '-'),
                  const SizedBox(height: 10),
                  _infoRow(context, 'Email', branch.email ?? '-'),
                  const SizedBox(height: 10),
                  _infoRow(context, 'Phone', branch.phoneNumber ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 16),
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

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
