import 'package:amazon_clone/common/widgets/custom_text_widget.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utilts.dart';
import 'package:amazon_clone/features/address/service/address_service.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay/pay.dart';

class AddressScreem extends ConsumerStatefulWidget {
  final double sum;
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
  final formkey = GlobalKey<FormState>();

  final Future<PaymentConfiguration> _googlePayConfigFuture =
      PaymentConfiguration.fromAsset('gpay.json');

  @override
  void dispose() {
    houseController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  String addressTobeUsed = "";

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

  void onGooglePayResult(res, BuildContext context) {
    final user = ref.watch(userProvider)!;
    if (user.address != addressTobeUsed) {
      ref
          .read(addressServiceProvider)
          .saveAddress(context: context, address: addressTobeUsed);
    }
    ref.read(addressServiceProvider).placeOrder(
        context: context, address: addressTobeUsed, totalSum: widget.sum);
  }

  void payPressed(
      String addresseFromProvider, User user, BuildContext context) {
    addressTobeUsed = "";
    bool isForm = houseController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    if (isForm) {
      if (formkey.currentState!.validate()) {
        addressTobeUsed =
            "${houseController.text}, ${areaController.text},${cityController.text}-${pincodeController.text} ";
      } else {
        throw Exception("Please Enter all the values!");
      }
    } else if (addresseFromProvider.isNotEmpty) {
      addressTobeUsed = user.address;
    } else {
      showSnackBar(context, "Error");
    }
    print(addressTobeUsed);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    // final address = "Wall Street";
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
            if (user.address.isNotEmpty)
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
                        user.address,
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
                key: formkey,
                child: Column(
                  children: [
                    CustomTextField(
                        controller: houseController,
                        hintText: "Flat, House no, Building"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        controller: areaController, hintText: "Area, Street"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        controller: pincodeController, hintText: "Pincode"),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        controller: cityController, hintText: "Town/City"),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            FutureBuilder<PaymentConfiguration>(
                future: _googlePayConfigFuture,
                builder: (context, snapshot) => snapshot.hasData
                    ? GooglePayButton(
                        paymentConfiguration: snapshot.data!,
                        paymentItems: paymentItems,
                        onPressed: () =>
                            payPressed(user.address, user, context),
                        type: GooglePayButtonType.buy,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: (res) =>
                            onGooglePayResult(res, context),
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      )),
    );
  }
}
