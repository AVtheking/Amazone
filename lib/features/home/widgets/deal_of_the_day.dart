import 'package:amazon_clone/features/home/screens/product_detail_screen.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DealOfDay extends ConsumerStatefulWidget {
  const DealOfDay({super.key});

  @override
  ConsumerState<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends ConsumerState<DealOfDay> {
  Product? product;
  fetchProduct(BuildContext context) async {
    product = await ref
        .read(homeServiceProvider.notifier)
        .fetchDealOfDay(context: context, ref: ref);
    setState(() {});
  }

  void navigateToDetailScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product!),
      ),
    );
  }

  @override
  void initState() {
    fetchProduct(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: () => navigateToDetailScreen(context),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Image.network(
                      product!.images[0],
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text('\$100'),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 5, left: 15),
                      child: const Text(
                        'Ankit',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: product!.images
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Image.network(
                                    e,
                                    fit: BoxFit.contain,
                                    height: 80,
                                    width: 100,
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(vertical: 15)
                          .copyWith(left: 15),
                      child: const Text(
                        "See all the deals",
                        style:
                            TextStyle(color: Color.fromARGB(255, 11, 136, 153)),
                      ),
                    )
                  ],
                ),
              );
  }
}
