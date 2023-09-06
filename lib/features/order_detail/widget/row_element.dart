import 'package:flutter/material.dart';

class RowElements extends StatelessWidget {
  final String text;
  final String value;
  const RowElements({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 50,
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
