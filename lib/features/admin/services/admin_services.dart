// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utilts.dart';
import 'package:amazon_clone/main.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/sale.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final adminServiceProvider = Provider((ref) => AdminService(ref: ref));

class AdminService {
  final Ref _ref;
  AdminService({required Ref ref}) : _ref = ref;
  void sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required double quantity,
      required String category,
      required List<File> images,
      required WidgetRef ref}) async {
    try {
      final user = ref.read(userProvider)!;
      final cloudinary = CloudinaryPublic('djonersza', 'tvozhodt');
      List<String> imageUrl = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imageUrl.add(res.secureUrl);
      }
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        images: imageUrl,
        category: category,
      );
      http.Response res = await http.post(
        Uri.parse("$uri/admin/add-product"),
        body: product.toJson(),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Product added Successfully");
            Navigator.of(context).pop();
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Product>> fetchAllProduct(
      BuildContext context, WidgetRef ref) async {
    List<Product> products = [];
    try {
      final user = ref.read(userProvider)!;

      http.Response res = await http.get(
        Uri.parse("$uri/admin/get-product"),
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
      showSnackBar(context, e.toString());
    }
    return products;
  }

  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required WidgetRef ref,
      required VoidCallback onSuccess}) async {
    try {
      final user = ref.read(userProvider)!;
      http.Response res = await http.post(
          Uri.parse("$uri/admin/delete-product"),
          body: jsonEncode({'id': product.id}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token
          });
      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders({required BuildContext context}) async {
    List<Order> orders = [];
    try {
      final user = _ref.read(userProvider)!;
      http.Response res = await http.get(Uri.parse("$uri/admin/get-orders"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
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
      showSnackBar(context, e.toString());
    }
    return orders;
  }

  void changeStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    try {
      final user = _ref.read(userProvider)!;
      http.Response res = await http.post(
        Uri.parse("$uri/admin/change-status"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode(
          {'id': order.id, 'status': status},
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

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    List<Sale> sales = [];
    int totalEarning = 0;
    try {
      final user = _ref.read(userProvider)!;
      http.Response res = await http.get(
        Uri.parse("$uri/admin/analytics"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // print(res.body);
            var response = jsonDecode(res.body);
            totalEarning = response['totalEarning'];
            sales = [
              Sale("Mobiles", response['mobileEarning']),
              Sale("Essentials", response['essentialEarning']),
              Sale("Appliances", response['appliancesEarning']),
              Sale("Books", response['bookEarning']),
              Sale("Fashion", response['fashionEarning']),
            ];
            // print(sales);
          });
    } catch (e) {
      // print(e);
      showSnackBar(context, e.toString());
    }
    return {'sales': sales, 'totalEarning': totalEarning};
  }
}
