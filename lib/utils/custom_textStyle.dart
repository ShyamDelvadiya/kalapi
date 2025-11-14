import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/utils/diamension.dart';

class AppTextStyle {
  static TextStyle titleStyle(BuildContext context) => GoogleFonts.mulish(
    fontSize: Dimension.fontSize20,
    fontWeight: FontWeight.w800,
    color: AppColors.titleColor(context),
  );

  static TextStyle subTitleStyle(BuildContext context) => GoogleFonts.mulish(
    fontSize: Dimension.fontSize16,
    fontWeight: FontWeight.w500,
    color: AppColors.subTitleColor(context),
  );
}
