import 'package:amazon_clone/common/widgets/sign_up_button.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/address/screen/address_screen.dart';
import 'package:amazon_clone/features/cart/widget/cart_product.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  void navigateToSearchScreen(BuildContext context, String value) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SearchScreen(query: value)));
  }

  void navigateToAddressScreen(BuildContext context, double sum) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddressScreem(sum: sum),
      ),
    );
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double sum = 0;
    final user = ref.watch(userProvider)!;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
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
                      onFieldSubmitted: (value) =>
                          navigateToSearchScreen(context, value),
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "Search Amazon.in",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                          filled: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              size: 23,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none),
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          )),
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
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(children: [
        const AddressBox(),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            const Text(
              "Subtotal",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "\$$sum",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SignUpButton(
            text: "Procced to buy (${user.cart.length} item)",
            onTap: () {
              navigateToAddressScreen(context, sum);
            },
            color: const Color.fromARGB(248, 247, 211, 5),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 1,
          color: Colors.black12,
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: user.cart.length,
              itemBuilder: (context, index) {
                final productCart = user.cart[index];
                final product = Product.fromMap(productCart['product']);
                final quantity = productCart['quantity'];
                return CartProduct(
                  product: product,
                  quantity: quantity,
                );
              }),
        )
      ]),
    );
  }
}
