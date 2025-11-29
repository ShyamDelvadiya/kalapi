import 'package:flutter/cupertino.dart';
import 'package:kalapi/utils/safe_google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/utils/diamension.dart';

class AppTextStyle {
  static TextStyle titleStyle(BuildContext context) => SafeGoogleFonts.mulish(
    fontSize: Dimension.fontSize20,
    fontWeight: FontWeight.w800,
    color: AppColors.titleColor(context),
  );

  static TextStyle subTitleStyle(BuildContext context) =>
      SafeGoogleFonts.mulish(
        fontSize: Dimension.fontSize16,
        fontWeight: FontWeight.w500,
        color: AppColors.subTitleColor(context),
      );
}
