import 'package:amazon_clone/common/widgets/sign_up_button.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/features/search/widget/ratting_bar.dart';
import 'package:amazon_clone/features/services/services/home_services.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  double avgRating = 0;
  double myRating = 0;
  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    final user = ref.read(userProvider)!;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId == user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
    setState(() {});
  }

  void navigateToSearchScreen(BuildContext context, String value) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SearchScreen(query: value)));
  }

  void updateRating(BuildContext context, Product product, double rating) {
    setState(() {
      ref.watch(homeServiceProvider.notifier).rateProduct(
          context: context,
          ref: ref,
          product: product,
          rating: rating,
          onSuccess: () {
            setState(() {});
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 42,
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      controller: _searchController,
                      onFieldSubmitted: (value) =>
                          navigateToSearchScreen(context, value),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none),
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.search,
                                size: 23,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 1)),
                          hintText: "Search Amazon.in",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17)),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 42,
                  child: const Icon(
                    Icons.mic,
                    size: 25,
                  ))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id!),
                  RatingBarWidget(rating: avgRating),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.product.name,
                style: const TextStyle(fontSize: 20),
              ),
              CarouselSlider(
                items: widget.product.images.map((e) {
                  return Builder(
                      builder: (BuildContext context) => Image.network(
                            e,
                            fit: BoxFit.fitWidth,
                            height: 200,
                          ));
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: 300,
                ),
              ),
              Container(
                color: Colors.black12,
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Deal Price: ",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      children: [
                        TextSpan(
                          text: "\$${widget.product.price}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(widget.product.description),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.black12,
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SignUpButton(
                  onTap: () {},
                  text: "Buy Now",
                  color: GlobalVariables.secondaryColor,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SignUpButton(
                  onTap: () {},
                  text: "Add to Cart",
                  color: const Color.fromARGB(255, 233, 211, 19),
                ),
              ),
              Container(
                color: Colors.black12,
                height: 5,
              ),
              const Text(
                "Rate the product",
                style: TextStyle(fontSize: 22),
              ),
              RatingBar.builder(
                  initialRating: myRating,
                  allowHalfRating: true,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: GlobalVariables.secondaryColor,
                      ),
                  onRatingUpdate: (rating) {
                    updateRating(context, widget.product, rating);
                    setState(() {});
                  })
            ],
          ),
        ),
      ),
    );
  }
}
