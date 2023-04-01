import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const routeName = '/product-details';

  //final String title;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;

    final product = Provider.of<Products>(context)
        .items
        .firstWhere((element) => element.id == productId);
    //final products = productData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
