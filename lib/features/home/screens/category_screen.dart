import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/accounts/widgets/product_widget.dart';
import 'package:amazon_clone/features/home/screens/product_detail_screen.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String category;
  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  void navigateToProductDetailScreen(BuildContext context, Product product) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product)));
  }

  final HomeService homeService = HomeService();
  List<Product>? products;
  fetchAllProducts(BuildContext context) async {
    products = await homeService.fetchCategoryProduct(
        context: context, category: widget.category, ref: ref);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(widget.category),
          centerTitle: true,
        ),
      ),
      body: products == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Keep shopping for ${widget.category}",
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products!.length,
                      itemBuilder: (context, index) {
                        final productData = products![index];
                        return GestureDetector(
                          onTap: () => navigateToProductDetailScreen(
                              context, productData),
                          child: Column(
                            children: [
                              Container(
                                height: 140,
                                padding:
                                    const EdgeInsets.only(left: 5, top: 10),
                                child:
                                    ProductWidget(image: productData.images[0]),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 15, top: 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  productData.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
