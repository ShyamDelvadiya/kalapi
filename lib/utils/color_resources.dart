import 'package:flutter/material.dart';

class AppColors {
  static Color titleColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF0EFFF)
          : const Color(0xFF263238);

  // static Color subTitleColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
  //     ? const Color(0xFFF9FDFF)
  //     : const Color(0xFF263238).withOpacity(0.5);

  static Color subTitleColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF9FDFF).withOpacity(0.50)
          : const Color(0xFF263238).withOpacity(0.50);

  static Color subTitleWithOutOpeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF9FDFF)
          : const Color(0xFF263238);

  static Color primaryColorStudent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0780D3)
          : const Color(0xFF0396FB);

  static Color primaryColorOwner(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF01A5AA)
          : const Color(0xFF01A5AA);

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF0EFFF)
          : const Color(0xFF263238);

  static Color unselectBoxBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF9FDFF).withOpacity(0.04)
          : const Color(0xFFE6E6E6);

  static Color backGroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001624)
          : const Color(0xFFFFFFFF);

  static Color pgOwnerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF3804D)
          : const Color(0xFFF9E724);

  static Color studentColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF3CC4D)
          : const Color(0xFF18E25B);

  static Color whiteColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFFFFFFF);

  static Color studentCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0A1F2D)
          : const Color(0xFFFFFFFF).withOpacity(0.52);

  static Color blackColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF000000)
          : const Color(0xFF000000);

  static Color blackWhiteColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF000000);

  static Color otpBorderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF01A5AA)
          : const Color(0xFF01A5AA);

  static Color starColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFB3261E)
          : const Color(0xFFB3261E);

  static Color fillColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001C2C)
          : const Color.fromRGBO(38, 50, 56, 0.05);

  static Color boxGradiant(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF042E48)
          : const Color(0xFFF3F3F3);

  static Color boxGradiant2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001522)
          : const Color(0xFFEEEEEE);

  static Color redColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFB00101)
          : const Color(0xFFB00101);

  static Color rentDueBackGround(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF002339)
          : const Color(0xFFFAFFFB);

  static Color greenColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1B9039)
          : const Color(0xFF1B9039);

  static Color cardBackGround(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFDEFEFF)
          : const Color(0xFFDEFEFF);

  static Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0A1F2D)
          : const Color(0xFF263238).withOpacity(0.55);

  static Color sameCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0A1F2D).withOpacity(0.40)
          : const Color(0xFFFFFFFF).withOpacity(0.55);

  static Color incomeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF388E3D)
          : const Color(0xFF388E3D);

  static Color monthBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFDBEBEC)
          : const Color(0xFFDBEBEC);

  static Color umColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFCCCCCC)
          : const Color(0xFFCCCCCC);

  static Color dashBoardBackground1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF002C2D)
          : const Color(0xFF0570B9);

  static Color dashBoardBackground2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF003C66)
          : const Color(0xFF19A144);

  static Color dashBoardSheet(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF00080D)
          : const Color(0xFFFBFFFF);

  static Color studentBackGround(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF00080D)
          : const Color(0xFFFFFFFF);

  static Color dashBoardText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF9FDFF)
          : const Color(0xFF263238).withOpacity(0.80);

  static Color dashBoardCard1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001F33)
          : const Color(0xFFEDFCF2);

  static Color dashBoardCard2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001F33)
          : const Color(0xFFFEF6EE);

  static Color dashBoardCard3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001F33)
          : const Color(0xFFFEF3F2);

  static Color dashBoardCard4(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001F33)
          : const Color(0xFFF5F2FE);

  static Color dividerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFEDFCF2)
          : const Color(0xFFF2F4F7);

  static Color pgBorderColor1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF2F4F7).withOpacity(0.20)
          : const Color(0xFFF2F4F7);

  static Color pgBorderColor2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF2F4F7).withOpacity(0.20)
          : const Color(0xFFF2F4F7);

  static Color bottomColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF001F33)
          : const Color(0xFFFFFFFF);

  static Color notificationCard1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF272260)
          : const Color(0xFF6ABCF4);

  static Color notificationCard2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3D1561)
          : const Color(0xFF48C871);

  static Color dashBoardBackground1ForStudent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF114B73)
          : const Color(0xFF0570B9);

  static Color dashBoardBackground2ForStudent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF083B19)
          : const Color(0xFF19A144);

  static Color searchBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFE9E9E9).withOpacity(0.09)
          : const Color(0xFFFFFFFF);

  static Color categoryBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFFFFF).withOpacity(0.02)
          : const Color(0xFFF0F9FF);

  static Color gradiantBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color.fromRGBO(0, 15, 26, 1)
          : const Color.fromRGBO(50, 143, 207, 1);

  static Color gradiantBorder2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color.fromRGBO(0, 63, 67, 0.68)
          : const Color.fromRGBO(17, 177, 189, 0.68);

  static Color gradiantBorder3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color.fromRGBO(233, 137, 76, 0)
          : const Color.fromRGBO(115, 53, 15, 0);

  static Color titleColorDetails(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF0EFFF).withOpacity(0.7)
          : const Color(0xFF263238);

  // Meal colors for attendance - Subtle version
  static Color breakfastColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF90A4AE) // Saddle brown - more muted
          : const Color(0xFF546E7A);

  static Color breakfastColorLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFA0522D) // Sienna - slightly lighter
          : const Color(0xFFA0522D);

  static Color lunchColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4682B4) // Steel blue - more professional
          : const Color(0xFF4682B4);

  static Color lunchColorLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF5F9EA0) // Cadet blue - muted
          : const Color(0xFF5F9EA0);

  static Color dinnerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF663323) // Rebecca purple - less bright
          : const Color(0xFF663355);

  static Color dinnerColorLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF7B68EE) // Medium slate blue
          : const Color(0xFF7B68EE);

  static Color dashBoardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFEFFEFF).withOpacity(0.05)
          : const Color(0xFFADFFF1).withOpacity(0.20);
}
