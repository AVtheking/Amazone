// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utilts.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final homeServiceProvider =
    StateNotifierProvider<HomeService, bool>((ref) => HomeService());

class HomeService extends StateNotifier<bool> {
  HomeService() : super(false);
  Future<List<Product>> fetchCategoryProduct(
      {required BuildContext context,
      required String category,
      required WidgetRef ref}) async {
    List<Product> products = [];
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.get(
        Uri.parse("$uri/api/product?category=$category"),
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
            products.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      // print(e.toString());
      showSnackBar(context, e.toString());
    }
    return products;
  }

  Future<List<Product>> fetchProductOnSearch({
    required BuildContext context,
    required String query,
    required WidgetRef ref,
  }) async {
    List<Product> products = [];
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.get(
        Uri.parse(
          "$uri/api/product/search/$query",
        ),
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
            products.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      // print(e.toString());
      showSnackBar(context, e.toString());
    }
    return products;
  }

  void rateProduct(
      {required BuildContext context,
      required WidgetRef ref,
      required Product product,
      required double rating,
      required VoidCallback onSuccess}) async {
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.post(
        Uri.parse("$uri/api/rate-product"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode(
          {
            'id': product.id!,
            'rating': rating,
          },
        ),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
