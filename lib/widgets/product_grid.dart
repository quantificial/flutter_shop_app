import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.showFavorites,
  });

  final bool showFavorites;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        showFavorites ? productData.favoriteItems : productData.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      // use nested change notifier provider
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          // create: (context) {
          //   return products[index];
          // },
          child: ProductItem()
          // id: products[index].id,
          // title: products[index].title,
          // imageUrl: products[index].imageUrl),
          ),
      itemCount: products.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}
