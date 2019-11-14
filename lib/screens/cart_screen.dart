import 'package:bespoke/providers/cart.dart';
import 'package:bespoke/providers/orders.dart';
import 'package:bespoke/screens/order_screen.dart';
import 'package:bespoke/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 6,
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Spacer(),
                  Chip(
                    padding: EdgeInsets.all(8),
                    label: Text(
                      "\$ ${cart.totalAmount.toStringAsFixed(2)}",
                    ),
                  ),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) => CartItem(
                cart.items.values.toList()[index],
                cart.items.keys.toList()[index],
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading ? CircularProgressIndicator() : Text(
        "ORDER NOW",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: (isLoading || widget.cart.items.isEmpty) ? null : () async {
        setState(() {
          isLoading = true;
        });

        await Provider.of<Orders>(
          context,
          listen: false,
        ).addOrder(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        );

        setState(() {
          isLoading = false;
        });
        widget.cart.clear();

        Navigator.of(context).pushNamed(OrderScreen.routeName);
      },
    );
  }
}

