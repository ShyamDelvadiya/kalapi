import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kalapi/utils/app_constrants.dart';
import 'package:kalapi/utils/color_resources.dart';

/// A reusable row with Privacy Policy and Terms links.
class PolicyLinksRow extends StatelessWidget {
  final Color? textColor;
  final MainAxisAlignment alignment;
  final bool underline;

  const PolicyLinksRow({
    super.key,
    this.textColor,
    this.alignment = MainAxisAlignment.center,
    this.underline = true,
  });

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Failed to open',
        url,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  TextStyle _style(BuildContext context) {
    final base = GoogleFonts.outfit(
      fontSize: 13,
      color: textColor ?? AppColors.titleColor(context),
      fontWeight: FontWeight.w500,
    );
    return underline
        ? base.copyWith(decoration: TextDecoration.underline)
        : base;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        TextButton(
          onPressed: () => _openUrl(AppLinks.privacyPolicy),
          child: Text('Privacy Policy', style: _style(context)),
        ),
        const SizedBox(width: 12),
        Container(
          width: 1,
          height: 14,
          color: (textColor ?? AppColors.titleColor(context)).withOpacity(0.4),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () => _openUrl(AppLinks.termsAndConditions),
          child: Text('Terms & Conditions', style: _style(context)),
        ),
      ],
    );
  }
}

/// Shows a themed bottom sheet with policy links.
Future<void> showPoliciesBottomSheet(BuildContext context) async {
  final bg = AppColors.backGroundColor(context);
  final titleColor = AppColors.titleColor(context);
  await showModalBottomSheet(
    context: context,
    backgroundColor: bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: titleColor),
                const SizedBox(width: 8),
                Text(
                  'Legal',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: titleColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'View our policies:',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: titleColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            PolicyLinksRow(
              alignment: MainAxisAlignment.start,
              underline: true,
              textColor: AppColors.primaryColorStudent(context),
            ),
          ],
        ),
      );
    },
  );
}
