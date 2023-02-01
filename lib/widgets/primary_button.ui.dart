import 'package:employee/const/color.const.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;

  const PrimaryButton(
      {super.key,
      required this.title,
      this.onPressed,
      this.color,
      this.width,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 70.0,
        width: width,
        decoration: BoxDecoration(
          color: color ?? AppColors.lightPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(color: textColor ?? Colors.white, fontSize: 18),
        )),
      ),
    );
  }
}
