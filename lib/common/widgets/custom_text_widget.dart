import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPass;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPass,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
    );
  }
}
