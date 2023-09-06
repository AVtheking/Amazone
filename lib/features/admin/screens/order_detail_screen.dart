import 'package:amazon_clone/features/accounts/widgets/product_widget.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/order_detail/screens/order_detail.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminOrderDetailScreen extends ConsumerStatefulWidget {
  const AdminOrderDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AdminOrderDetailScreenState();
}

class AdminOrderDetailScreenState
    extends ConsumerState<AdminOrderDetailScreen> {
  List<Order>? orders;
  fetchAllOrders() async {
    orders =
        await ref.read(adminServiceProvider).fetchAllOrders(context: context);
    setState(() {});
  }

  @override
  void initState() {
    fetchAllOrders();
    super.initState();
  }

  void navigateToDetailScreen(BuildContext context, Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 6, crossAxisCount: 2),
            itemCount: orders!.length,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: () => navigateToDetailScreen(context, orderData),
                child: ProductWidget(
                  image: orderData.products[0].images[0],
                ),
              );
            }));
  }
}
