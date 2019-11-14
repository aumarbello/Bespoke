import 'package:bespoke/providers/orders.dart';
import 'package:bespoke/widgets/orders_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSaveOrders(),
          builder: (ctx, state) {
            if (state.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (state.error == null) {
                return Consumer<Orders>(
                  builder: (ctx, ordersData, _) {
                    return ListView.builder(
                      itemBuilder: (_, index) =>
                          OrdersItem(ordersData.orders[index]),
                      itemCount: ordersData.orders.length,
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "Something went wrong",
                  ),
                );
              }
            }
          }),
    );
  }
}
