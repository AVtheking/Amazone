import 'package:amazon_clone/common/widgets/custom_text_widget.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay/pay.dart';

class AddressScreem extends ConsumerStatefulWidget {
  final int sum;
  const AddressScreem({
    super.key,
    required this.sum,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressScreemState();
}

class _AddressScreemState extends ConsumerState<AddressScreem> {
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    houseController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  List<PaymentItem> paymentItems = [];
  @override
  void initState() {
    paymentItems.add(PaymentItem(
      amount: widget.sum.toString(),
      label: "Total",
      status: PaymentItemStatus.final_price,
    ));
    super.initState();
  }

  void onGooglePayResult(res) {}

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final address = "Wall Street";
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (address.isNotEmpty)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "OR",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            Form(
                child: Column(
              children: [
                CustomTextField(
                    controller: houseController,
                    hintText: "Flat, House no, Building"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: houseController, hintText: "Area, Street"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: houseController, hintText: "Pincode"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: houseController, hintText: "Town/City"),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GooglePayButton(
                  paymentConfigurationAsset: "gpay.json",
                  onPaymentResult: onGooglePayResult,
                  height: 50,
                  margin: const EdgeInsets.only(top: 15.0),
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  width: double.infinity,
                  type: GooglePayButtonType.buy,
                  paymentItems: paymentItems),
            )
          ],
        ),
      )),
    );
  }
}
