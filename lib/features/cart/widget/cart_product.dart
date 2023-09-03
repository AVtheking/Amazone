import 'package:amazon_clone/features/home/screens/product_detail_screen.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/search/widget/ratting_bar.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartProduct extends ConsumerStatefulWidget {
  final Product product;
  final int quantity;
  const CartProduct({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  ConsumerState<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends ConsumerState<CartProduct> {
  void navigateToProductDetailScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: widget.product),
      ),
    );
  }

  void addToCart(BuildContext context) {
    ref
        .watch(homeServiceProvider.notifier)
        .addToCart(context: context, product: widget.product, ref: ref);
  }

  void deleteProduct(BuildContext context) {
    ref.watch(homeServiceProvider.notifier).deleteToCart(
          context: context,
          product: widget.product,
          ref: ref,
        );
  }

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    double avgRating = 0;
    final user = ref.read(userProvider)!;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
    return GestureDetector(
      onTap: () => navigateToProductDetailScreen(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    widget.product.images[0],
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
                        widget.product.name,
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
                        "\$${widget.product.price}",
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
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black12,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => deleteProduct(context),
                  child: Container(
                    width: 35,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.remove,
                      size: 18,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.5,
                      )),
                  child: Container(
                    width: 35,
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      widget.quantity.toString(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => addToCart(context),
                  child: Container(
                    width: 35,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
