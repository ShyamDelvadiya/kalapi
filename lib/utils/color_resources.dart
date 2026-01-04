import 'package:flutter/material.dart';

class AppColors {
  static Color titleColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFF8E1) // Warm white
          : const Color(0xFF3E2723); // Dark brown

  static Color subTitleColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFECB3).withOpacity(0.7)
          : const Color(0xFF5D4037).withOpacity(0.7); // Brownish grey

  static Color subTitleWithOutOpeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFECB3)
          : const Color(0xFF5D4037);

  static Color primaryColorStudent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFF6F00) // Amber/Orange
          : const Color(0xFFFF8F00);

  static Color primaryColorOwner(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFD84315) // Deep Orange
          : const Color(0xFFBF360C);

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF5D4037)
          : const Color(0xFFD7CCC8);

  static Color unselectBoxBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFF8E1).withOpacity(0.1)
          : const Color(0xFFEFEBE9);

  static Color backGroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF210A00) // Very dark brown
          : const Color(0xFFFFF8E1); // Creamy white

  static Color pgOwnerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFAB91)
          : const Color(0xFFFFCCBC);

  static Color studentColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFD54F)
          : const Color(0xFFFFE082);

  static Color whiteColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFFFFFFF);

  static Color studentCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFFFFF);

  static Color blackColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF000000)
          : const Color(0xFF000000);

  static Color blackWhiteColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF3E2723);

  static Color otpBorderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFF6F00)
          : const Color(0xFFFF8F00);

  static Color starColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFD32F2F)
          : const Color(0xFFC62828);

  static Color fillColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFF3E0);

  static Color boxGradiant(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4E342E)
          : const Color(0xFFFFF8E1);

  static Color boxGradiant2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFECB3);

  static Color redColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFB71C1C)
          : const Color(0xFFC62828);

  static Color rentDueBackGround(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFEBEE);

  static Color greenColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2E7D32)
          : const Color(0xFF388E3D);

  static Color cardBackGround(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFF8E1);

  static Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFFFFF);

  static Color sameCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4E342E)
          : const Color(0xFFFFF3E0);

  static Color incomeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF43A047)
          : const Color(0xFF2E7D32);

  static Color monthBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4E342E)
          : const Color(0xFFFFECB3);

  static Color umColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBCAAA4)
          : const Color(0xFF8D6E63);

  static Color dashBoardBackground1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBF360C)
          : const Color(0xFFFF6F00);

  static Color dashBoardBackground2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFE65100)
          : const Color(0xFFFF8F00);

  static Color dashBoardSheet(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF210A00)
          : const Color(0xFFFFF8E1);

  static Color studentBackGround(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF210A00)
          : const Color(0xFFFFF3E0);

  static Color dashBoardText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFECB3)
          : const Color(0xFF3E2723);

  static Color dashBoardCard1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFF3E0);

  static Color dashBoardCard2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFE0B2);

  static Color dashBoardCard3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFCCBC);

  static Color dashBoardCard4(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFFAB91);

  static Color dividerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF5D4037)
          : const Color(0xFFD7CCC8);

  static Color pgBorderColor1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF5D4037).withOpacity(0.20)
          : const Color(0xFFD7CCC8);

  static Color pgBorderColor2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF5D4037).withOpacity(0.20)
          : const Color(0xFFD7CCC8);

  static Color bottomColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF210A00)
          : const Color(0xFFFFFFFF);

  static Color notificationCard1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBF360C)
          : const Color(0xFFFF6F00);

  static Color notificationCard2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFE65100)
          : const Color(0xFFFF8F00);

  static Color dashBoardBackground1ForStudent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBF360C)
          : const Color(0xFFFF6F00);

  static Color dashBoardBackground2ForStudent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFE65100)
          : const Color(0xFFFF8F00);

  static Color searchBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723).withOpacity(0.3)
          : const Color(0xFFFFF3E0);

  static Color categoryBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723).withOpacity(0.2)
          : const Color(0xFFFFF8E1);

  static Color gradiantBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3E2723)
          : const Color(0xFFFF6F00);

  static Color gradiantBorder2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4E342E)
          : const Color(0xFFFF8F00);

  static Color gradiantBorder3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF5D4037)
          : const Color(0xFFFFB74D);

  static Color titleColorDetails(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFECB3)
          : const Color(0xFF3E2723);

  // Meal colors for attendance - Warm food colors
  static Color breakfastColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFB74D) // Orange
          : const Color(0xFFFF9800);

  static Color breakfastColorLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFCC80)
          : const Color(0xFFFFB74D);

  static Color lunchColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFF7043) // Deep Orange
          : const Color(0xFFFF5722);

  static Color lunchColorLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFF8A65)
          : const Color(0xFFFF7043);

  static Color dinnerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF8D6E63) // Brown
          : const Color(0xFF795548);

  static Color dinnerColorLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFA1887F)
          : const Color(0xFF8D6E63);

  static Color dashBoardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFF8E1).withOpacity(0.05)
          : const Color(0xFF3E2723).withOpacity(0.10);
}
