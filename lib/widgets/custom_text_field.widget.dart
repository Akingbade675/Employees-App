import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isRequired;
  final int? length;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  const CustomTextField(
      {super.key,
      required this.hint,
      this.controller,
      this.isPassword = false,
      this.length,
      this.keyboardType,
      this.inputFormatters,
      this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: TextFormField(
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: length,
          obscureText: isPassword,
          validator: (val) {
            if (isRequired) {
              if (val!.isEmpty) {
                return "This field is required";
              }
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
              counterText: "", border: InputBorder.none, hintText: hint),
        ),
      ),
    );
  }
}
