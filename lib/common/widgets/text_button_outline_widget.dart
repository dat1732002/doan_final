import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';

class TextButtonOutlineWidget extends StatelessWidget {
  final String? label;
  final Function()? onPressed;

  const TextButtonOutlineWidget({
    super.key,
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => ColorUtils.whiteColor,
        ),
        minimumSize: MaterialStateProperty.resolveWith(
          (states) => const Size(double.infinity, 60),
        ),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              width: 1.2,
              color: ColorUtils.primaryColor,
            ),
          ),
        ),
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
