import 'package:amazon_clone/features/search/widget/ratting_bar.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatelessWidget {
  final Product product;
  const SearchProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 145,
                width: 135,
                margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Image.network(
                  product.images[0],
                  fit: BoxFit
                      .contain, // Use BoxFit.contain to fit the image within the container
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                      width: 200,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: const RatingBar(rating: 4)),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "\$${product.price}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Eligible for FREE shipping",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      "In Stock",
                      style: const TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
