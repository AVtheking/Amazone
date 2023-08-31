import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final String image;
  const ProductWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 180,
          child: Image.network(
            image,
            fit: BoxFit.fitHeight,
            width: 180,
          ),
        ),
      ),
    );
  }
}
