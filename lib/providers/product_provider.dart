import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odoorpcscratch/models/product_template.dart';
import 'package:odoorpcscratch/services/rpc_product.dart';

final productProvider = FutureProvider((ref) async {
  final productData = await ref.read(httpProductProvider.future);
  return productData.getProducts();
});
// final productData = await client.callKw({
//   'model': 'product.template',
//   'method': 'create',
//   'args': [
//     {'name': 'MyProduct'}
//   ],
//   'kwargs': {},
// });

class ProductTemplateNotifier extends AsyncNotifier<List<ProductTemplate>> {
  @override
  build() async {
    final productProvider = await ref.watch(httpProductProvider.future);
    final raw = await productProvider.getProducts();
    return [...raw.map((product) => ProductTemplate.fromJson(product))];
  }
}

final productTemplateNotifier =
    AsyncNotifierProvider<ProductTemplateNotifier, List<ProductTemplate>>(() {
  return ProductTemplateNotifier();
});
