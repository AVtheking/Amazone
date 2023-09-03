import 'package:amazon_clone/constants/global_variable.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  const SignUpButton(
      {super.key, required this.onTap, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        primary: color,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == GlobalVariables.secondaryColor
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
