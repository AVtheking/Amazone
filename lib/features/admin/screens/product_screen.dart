import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/accounts/widgets/product_widget.dart';
import 'package:amazon_clone/features/admin/screens/add_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

void navigateToAddProduct(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const AddProductScreen()));
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  // final AdminService adminService = AdminService();
  List<Product>? productList;

  fetchAllProducts(BuildContext context) async {
    productList =
        await ref.read(adminServiceProvider).fetchAllProduct(context, ref);
    setState(() {});
  }

  void deleteProduct(BuildContext context, Product product, int index) {
    ref.read(adminServiceProvider).deleteProduct(
        context: context,
        product: product,
        ref: ref,
        onSuccess: () {
          setState(() {
            productList!.removeAt(index);
          });
        });
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: productList!.length,
              itemBuilder: ((context, index) {
                final productData = productList![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: ProductWidget(image: productData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              deleteProduct(context, productData, index);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    )
                  ],
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddProduct(context);
        },
        shape: const CircleBorder(),
        backgroundColor: GlobalVariables.selectedNavBarColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
