import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart' as CustomBadge;

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isFavourite = false; 

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('MyShop'), actions: [
        const BottomSheetExample(),
        PopupMenuButton(
          onSelected: (value) {
            setState(() {
              if (value == FilterOptions.Favorites) {
                //productsContainer.showFavoritesOnly();
                _isFavourite = true;
              } else {
                _isFavourite = false;
                //productsContainer.showAll();
              }
            });
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text('Only Favorites')),
              const PopupMenuItem(value: FilterOptions.All, child: Text('Show All')),
            ];
          },
        ),
        Consumer<Cart>(
          builder: (context, cart, child) {
            return CustomBadge.Badge(
                value: cart.itemCount.toString(),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ));
          },
        ),
        const Icon(Icons.access_alarm)
      ]),
      // grid view
      // the gird item ratio is for example
      // 300px width vs 200px height => 3 / 2
      body: ProductGrid(
        showFavorites: _isFavourite,
      ),
      drawer: const AppDrawer(),
    );
  }
}

// demo bottom sheet
class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Icon(Icons.info_sharp),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 500,
                color: Colors.amber,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
