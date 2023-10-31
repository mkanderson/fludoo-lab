import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odoorpcscratch/providers/client_provider.dart';
import 'dart:developer';

class OdooProductRepository {
  OdooProductRepository({required this.client});
  final OdooClient client;

  Future getProducts() async {
    final productData = await client.callKw({
      'model': 'product.template',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': false},
        'domain': [],
        'fields': ['id', 'name', 'list_price', 'default_code', 'image_512'],
        'limit': 180,
      },
    });
    log(">>>>> ${productData[0]['image_512']} <<<<<<<<");
    return productData;
  }

  Future createProduct(Map<String, Object> vals) async {
    final productData = await client.callKw({
      'model': 'product.template',
      'method': 'create',
      'args': [vals],
      'kwargs': {
        'context': {'bin_size': false},
      },
    });
    return productData;
  }
}

final httpProductProvider = FutureProvider<OdooProductRepository>((ref) async {
  OdooClient client = await ref.watch(odooClientProvider.future);
  return OdooProductRepository(client: client);
});
