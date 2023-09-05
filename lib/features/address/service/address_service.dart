// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utilts.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final addressServiceProvider = Provider((ref) => AddressService(ref: ref));

class AddressService {
  final Ref _ref;
  AddressService({required Ref ref}) : _ref = ref;
  void saveAddress({
    required BuildContext context,
    required String address,
  }) async {
    try {
      final user = _ref.read(userProvider)!;
      http.Response res = await http.post(
        Uri.parse("$uri/api/add-address"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode({"address": address}),
      );
      // print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User updated =
                user.copyWith(address: jsonDecode(res.body)['address']);
            _ref.read(userProvider.notifier).update((state) =>
                updated); //wierd error this line is not updating user but why
          });
      // print(jsonDecode(res.body)["address"]); when I print this then it is showing updated address
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    try {
      final user = _ref.read(userProvider)!;
      http.Response res = await http.post(
        Uri.parse("$uri/api/order"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode(
          {
            "cart": user.cart,
            "address": address,
            "totalPrice": totalSum,
          },
        ),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your order has been places successfully");
            _ref.read(userProvider.notifier).update((state) => user
                .copyWith(cart: [], address: jsonDecode(res.body)["address"]));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
