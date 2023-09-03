import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
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

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                              borderRadius: BorderRadius.circular(7)),
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
      body: const AddressBox(),
    );
  }
}
