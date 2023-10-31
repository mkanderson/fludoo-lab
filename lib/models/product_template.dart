import 'dart:convert';

import 'package:flutter/material.dart';

class ProductTemplate {
  const ProductTemplate(
      {required this.name,
      this.id,
      this.price,
      this.image_512,
      this.default_code});

  final String name;
  final int? id;
  final double? price;
  final String? image_512;
  final String? default_code;

  factory ProductTemplate.fromJson(Map<String, dynamic> json) {
    return ProductTemplate(
        name: json['name'],
        id: json['id'],
        price: json['list_price'],
        default_code:
            json['default_code'] is String ? json['default_code'] : '',
        image_512: json['image_512'] is String
            ? json['image_512'].replaceAll(RegExp(r'\s+'), '')
            : null);
  }
}
