import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFormField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final TextInputAction? inputAction;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;
  final Widget? suffixIcon;

  const SearchFormField({
    super.key,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.onChanged,
    this.inputAction,
    this.focusNode,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: focusNode,
          autofocus: true,
          controller: controller,
          onChanged: onChanged,
          textInputAction: inputAction,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            prefixIcon: prefixIcon ?? const SizedBox(),
            suffixIcon: suffixIcon ?? const SizedBox(),
            hintStyle: TextStyle(
              color: ColorUtils.textColor,
              fontSize: 14.sp,
            ),
            filled: true, // Thêm màu nền
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1,
              ),
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
