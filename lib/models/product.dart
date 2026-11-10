import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final Color  bgColor;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.bgColor,
    required this.category,
  });

  // Factory: build a Product from a Supabase row (Map<String, dynamic>)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:          json['id']          as String,
      name:        json['name']        as String,
      description: json['description'] as String? ?? '',
      price:       (json['price'] as num).toDouble(),
      emoji:       json['emoji']       as String? ?? '🍌',
      bgColor:     Color(json['bg_color'] as int),
      category:    json['category']    as String? ?? '',
    );
  }
}