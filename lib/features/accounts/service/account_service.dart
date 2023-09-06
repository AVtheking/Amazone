// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utilts.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final accountServiceProvider = Provider((ref) => AccountService(ref: ref));

class AccountService {
  final Ref _ref;
  AccountService({required Ref ref}) : _ref = ref;
  Future<List<Order>> fetchAllOrders({required BuildContext context}) async {
    List<Order> orders = [];
    try {
      final user = _ref.read(userProvider)!;
      http.Response res = await http.get(
        Uri.parse("$uri/api/all-orders"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              // print(jsonDecode(res.body)[i]);
              // print(jsonDecode(res.body)[i]['products']);

              orders.add(
                Order.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          });
    } catch (e) {
      // print(e);
      showSnackBar(context, e.toString());
    }
    return orders;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("x-auth-token", '');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
