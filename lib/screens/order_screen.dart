import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as widgets;

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return widgets.OrderItem(order: ordersData.orders[index]);
        },
        itemCount: ordersData.orders.length,
      ),
      drawer: AppDrawer(),
    );
  }
}
