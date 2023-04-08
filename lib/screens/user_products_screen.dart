import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});

  static const routeName = '/user-products';

  // drag and refresh
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    UserProductItem(
                        id: productData.items[index].id,
                        title: productData.items[index].title,
                        imageUrl: productData.items[index].imageUrl),
                    Divider(),
                  ],
                );
              },
              itemCount: productData.items.length,
            )),
      ),
    );
  }
}
