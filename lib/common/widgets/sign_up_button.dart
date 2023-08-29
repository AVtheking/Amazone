import 'package:amazon_clone/constants/global_variable.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const SignUpButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: GlobalVariables.secondaryColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
