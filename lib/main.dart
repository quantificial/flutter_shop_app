import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import 'providers/auth.dart';
import 'providers/products.dart';
import 'providers/cart.dart';
import 'screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //return ChangeNotifierProvider(
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        // ChangeNotifierProvider(
        //   create: (context) => Products(),
        // ),
        // products provider depends on auth provider to get the token
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', []),
          update: (context, value, previous) {
            return Products(
                value.token, previous == null ? [] : previous.items);
          },
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => Orders(),
        // ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', []),
          update: (context, value, previous) {
            return Orders(value.token, previous == null ? [] : previous.orders);
          },
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, v, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              // color theme
              // primarySwatch: Colors.purple,
              // accentColor: Colors.deepOrange,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato'),
          home: v.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            ProductsOverviewScreen.routeName: (context) =>
                ProductsOverviewScreen()
          },
        );
      }),
    );
  }
}
