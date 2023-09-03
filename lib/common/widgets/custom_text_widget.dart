import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPass;
  final int maxLines;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.isPass = false,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPass,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 207, 204, 204),
            width: 1,
          ),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}
