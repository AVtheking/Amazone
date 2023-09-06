import 'package:amazon_clone/common/widgets/sign_up_button.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final Order order;
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int currentState = 0;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentState = widget.order.status;
  }

  void navigateToSearchScreen(BuildContext context, String value) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SearchScreen(query: value)));
  }

  void changeStatus(int status) {
    if (status < 3) {
      ref.read(adminServiceProvider).changeStatus(
          context: context,
          status: status + 1,
          order: widget.order,
          onSuccess: () {
            setState(() {
              currentState += 1;
            });
          });
    }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View order details",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Date:       ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Order ID:          ${widget.order.id}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Order Total:       \$${widget.order.totalPrice}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Purchase Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              widget.order.products[i].images[0],
                              height: 120,
                              width: 120,
                              // fit: BoxFit.fitWidth,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.products[i].name,
                                    // softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("Qty: ${widget.order.quantity[i]}")
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Tracking",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Stepper(
                    currentStep: currentState,
                    controlsBuilder: (context, details) {
                      final user = ref.watch(userProvider)!;
                      if (user.type == "admin") {
                        return SignUpButton(
                          onTap: () => changeStatus(details.currentStep),
                          text: "Done",
                          color: GlobalVariables.secondaryColor,
                        );
                      }
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                          title: const Text("Pending"),
                          content:
                              const Text("Your order is yet to be delivered"),
                          isActive: currentState > 0,
                          state: currentState > 0
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const Text("Completed"),
                          content: const Text(
                              "Your order has been delivered! you are yet to sign"),
                          isActive: currentState > 1,
                          state: currentState > 1
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const Text("Recieved"),
                          content: const Text(
                              "Your order has been delivered! and signed by you"),
                          isActive: currentState > 2,
                          state: currentState > 2
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const Text("Deliverd"),
                          content: const Text(
                              "Your order has been delivered! and signed by you"),
                          isActive: currentState >= 3,
                          state: currentState >= 3
                              ? StepState.complete
                              : StepState.indexed),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
