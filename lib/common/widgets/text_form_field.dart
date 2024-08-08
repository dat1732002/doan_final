import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldCustomWidget extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputAction? inputAction;
  final Function(String value)? onChanged;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool isEnable;

  const TextFormFieldCustomWidget({
    Key? key,
    this.hint,
    this.label,
    this.controller,
    this.suffixIcon,
    this.onChanged,
    this.obscureText,
    this.inputAction,
    this.textInputType,
    this.validator,
    this.isEnable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          enabled: isEnable,
          controller: controller,
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          keyboardType: textInputType,
          textInputAction: inputAction,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 15.h,
            ),
            suffixIcon: suffixIcon ?? const SizedBox(),
            hintStyle: TextStyle(
              color: ColorUtils.textColor,
              fontSize: 14.sp,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: ColorUtils.primaryColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: ColorUtils.blueLightColor,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
