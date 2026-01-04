import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double? width;
  final Color? color;
  final Color? textcolor;
  final double? fontsize;
  final BorderRadius borderRadius;
  final bool isLoading;
  final Widget? loadingChild;

  CustomButton({
    required this.text,
    this.color,
    this.textcolor,
    this.fontsize = 16.33,
    required this.onPressed,
    this.height = 45,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(109)),
    this.isLoading = false,
    this.loadingChild,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      borderRadius: borderRadius,
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color ?? AppColors.primaryColorOwner(context),
        ),
        child: Center(
          child:
              isLoading
                  ? (loadingChild ??
                      SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textcolor ?? Colors.white,
                          ),
                        ),
                      ))
                  : Text(
                    text,
                    style: GoogleFonts.mulish(
                      color: textcolor ?? Colors.white,
                      fontSize: fontsize,
                      height: 16 / fontsize!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
        ),
      ),
    );
  }
}
