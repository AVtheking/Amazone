import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/accounts/service/account_service.dart';
import 'package:amazon_clone/features/accounts/widgets/product_widget.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Orders extends ConsumerStatefulWidget {
  const Orders({super.key});

  @override
  ConsumerState<Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<Orders> {
  List<Order>? orders;
  fetchUserOrders() async {
    orders =
        await ref.read(accountServiceProvider).fetchAllOrders(context: context);
    setState(() {});
  }

  @override
  void initState() {
    fetchUserOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Your Orders",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      "See all",
                      style: TextStyle(
                          color: GlobalVariables.selectedNavBarColor,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Container(
                height: 170,
                padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orders!.length,
                    itemBuilder: (context, index) {
                      final image = orders![index].products[0].images[0];
                      return ProductWidget(image: image);
                    }),
              )
            ],
          );
  }
}
