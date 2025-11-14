import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/utils/diamension.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final int? minLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  // final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;
  final bool isBorder;
  final String? labelText;
  final String? prefixText;
  final Widget? suffixImage;
  final Widget? prefixImage;
  final TextStyle? hintstyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final OutlineInputBorder? outlineInputBorder;
  final OutlineInputBorder? focusBorder;
  final bool readonly;
  final bool autofocus;
  final bool fillColorBool;
  final AutovalidateMode? autovalidate;
  final InputDecoration? decoration;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  void Function(String)? onChanged;
  void Function(String?)? onSubmit;
  void Function(String)? onFieldSubmitted;
  void Function()? onTap;
  CustomTextFormField({
    this.controller,
    this.hintstyle,
    this.textStyle,
    this.hintText,
    this.textInputType,
    this.maxLine,
    this.padding,
    this.minLine,
    this.focusNode,
    this.nextNode,
    this.prefixText,
    this.textInputAction,
    this.decoration,
    this.isPhoneNumber = false,
    this.autofocus = false,
    this.fillColorBool = false,
    this.readonly = false,
    this.validator,
    this.obscureText = false,
    this.validatorMessage,
    this.autovalidate = AutovalidateMode.onUserInteraction,
    this.capitalization = TextCapitalization.none,
    this.fillColor,
    this.isBorder = false,
    this.labelText,
    this.inputFormatters,
    this.onChanged,
    this.onSubmit,
    this.outlineInputBorder,
    this.focusBorder,
    this.prefixImage,
    this.onFieldSubmitted,
    this.onTap,
    this.suffixImage,
  });

  @override
  Widget build(context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            autofocus: autofocus,
            cursorColor: AppColors.titleColor(context),
            onTap: onTap,
            readOnly: readonly,
            onChanged: onChanged,
            style:
                textStyle ??
                GoogleFonts.mulish(
                  fontSize: Dimension.fontSize16,
                  color: AppColors.titleColor(context),
                  height: 20.8 / Dimension.fontSize16,
                  fontWeight: FontWeight.w500,
                ),
            obscureText: obscureText,
            textAlign: isBorder ? TextAlign.center : TextAlign.start,
            controller: controller,
            maxLines: maxLine ?? 1,
            minLines: minLine ?? 1,
            onSaved: onSubmit,
            textCapitalization: capitalization,
            maxLength: isPhoneNumber ? 10 : null,
            focusNode: focusNode,
            keyboardType: textInputType ?? TextInputType.text,
            initialValue: null,
            textInputAction: textInputAction ?? TextInputAction.next,
            onFieldSubmitted:
                onFieldSubmitted ??
                (v) {
                  FocusScope.of(context).requestFocus(nextNode);
                },
            inputFormatters: inputFormatters,
            autovalidateMode: autovalidate,
            validator: validator,
            decoration:
                decoration ??
                InputDecoration(
                  prefixText: prefixText,
                  prefixStyle: GoogleFonts.mulish(
                    fontSize: Dimension.fontSize16,
                    color: AppColors.titleColor(context),
                    height: 20.8 / Dimension.fontSize16,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  fillColor: fillColor,
                  filled: fillColorBool,
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding:
                      padding ?? EdgeInsets.symmetric(horizontal: 20),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixIcon: suffixImage,
                  prefixIcon: prefixImage,
                  hintText: hintText ?? '',
                  errorStyle: GoogleFonts.mulish(
                    color: AppColors.redColor(context),
                    fontSize: Dimension.fontSize12,
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle:
                      hintstyle ??
                      GoogleFonts.mulish(
                        fontSize: Dimension.fontSize16,
                        color: AppColors.titleColor(context).withOpacity(0.5),
                        height: 16 / Dimension.fontSize16,
                        fontWeight: FontWeight.w500,
                      ),
                  focusedBorder:
                      focusBorder == null
                          ? OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColors.borderColor(
                                context,
                              ).withOpacity(0.36),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          )
                          : focusBorder,
                  enabledBorder:
                      outlineInputBorder == null
                          ? OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColors.borderColor(
                                context,
                              ).withOpacity(0.36),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          )
                          : outlineInputBorder,
                ),
          ),
        ),
      ],
    );
  }
}
