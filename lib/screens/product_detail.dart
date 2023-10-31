import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odoorpcscratch/models/product_template.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductTemplate record;

  const ProductDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the product image
            if (record.image_512.toString() != 'false' &&
                record.image_512 != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.memory(
                  base64Decode(
                      record.image_512!.replaceAll(RegExp(r'\s+'), '')),
                ),
              ),
            // Display other product details
            Text('Price: ${record.price}'),
            Text('Code: ${record.default_code}'),
            // ... add other fields as needed
          ],
        ),
      ),
    );
  }
}
