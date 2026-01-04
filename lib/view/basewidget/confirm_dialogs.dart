import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';

Future<bool> confirmLogoutDialog(BuildContext context) async {
  final bg = AppColors.backGroundColor(context);
  final titleColor = AppColors.titleColor(context);
  final primary = AppColors.primaryColorStudent(context);

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: bg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: titleColor),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout? You will need to login again to continue.',
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: titleColor.withOpacity(0.85),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
