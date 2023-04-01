import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop')),
      // grid view
      // the gird item ratio is for example
      // 300px width vs 200px height => 3 / 2
      body: ProductGrid(),
    );
  }
}
