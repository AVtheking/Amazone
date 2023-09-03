// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utilts.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/user.dart';
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

  Future<Product> fetchDealOfDay(
      {required BuildContext context, required WidgetRef ref}) async {
    Product product = Product(
        name: '',
        description: '',
        quantity: 0,
        price: 0,
        images: [],
        category: '');
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.get(
        Uri.parse("$uri/api/deal-of-day"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            product = Product.fromJson(res.body);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }

  void addToCart(
      {required BuildContext context,
      required Product product,
      required WidgetRef ref}) async {
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.post(Uri.parse('$uri/api/add-to-cart'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token
          },
          body: jsonEncode({
            'id': product.id!,
          }));
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User updatedUser =
                user.copyWith(cart: jsonDecode(res.body)['cart']);
            ref.read(userProvider.notifier).update((state) => updatedUser);
            showSnackBar(context, "Item added successfully");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteToCart({
    required BuildContext context,
    required Product product,
    required WidgetRef ref,
  }) async {
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.delete(
        Uri.parse("$uri/api/delete-product/${product.id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User updatedUser =
                user.copyWith(cart: jsonDecode(res.body)['cart']);
            ref.read(userProvider.notifier).update((state) => updatedUser);
            showSnackBar(context, "Item deleted successfully");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
