// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

class Product {
  final String name;
  final String description;
  final double quantity;
  final double price;
  final List<dynamic> images;
  final String category;
  final String? id;
  final List<Rating>? rating;

  Product(
      {required this.name,
      required this.description,
      required this.quantity,
      required this.price,
      required this.images,
      required this.category,
      this.id,
      this.rating});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity.toDouble(),
      'price': price.toDouble(),
      'images': images,
      'category': category,
      'id': id,
      'rating': rating
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      quantity: (map['quantity'] is int)
          ? (map['quantity'] as int).toDouble()
          : map['quantity'].toDouble(),
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price'].toDouble(),
      images: List<dynamic>.from(map['images'] as List<dynamic>),
      category: map['category'] as String? ?? '',
      id: map['_id'] as String?,
      rating: map['ratings'] != null
          ? List<Rating>.from(
              (map['ratings'] as List<dynamic>).map(
                (x) => Rating.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
