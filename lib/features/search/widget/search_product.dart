import 'package:amazon_clone/features/home/screens/product_detail_screen.dart';
import 'package:amazon_clone/features/search/widget/ratting_bar.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProduct extends ConsumerWidget {
  final Product product;
  const SearchProduct({
    super.key,
    required this.product,
  });
  void navigateToProductDetailScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double totalRating = 0;
    double avgRating = 0;
    // final user = ref.read(userProvider)!;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }
    return GestureDetector(
      onTap: () => navigateToProductDetailScreen(context),
      child: Column(
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
                        child: RatingBarWidget(rating: avgRating)),
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
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: const Text(
                        "In Stock",
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
