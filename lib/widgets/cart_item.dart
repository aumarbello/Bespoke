import 'package:bespoke/models/cart_item.dart' as Model;
import 'package:bespoke/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final Model.CartItem cart;
  final String productId;

  CartItem(this.cart, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Are you sure?"),
                content: Text(
                  "Deleting item from cart can't be reversed",
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("No"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            });
      },
      background: Container(
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 8,
        ),
        padding: EdgeInsets.only(
          right: 20,
        ),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 36,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeProduct(
          productId,
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 8,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 8,
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "\S${cart.amount}",
                  ),
                ),
              ),
            ),
            title: Text(cart.title),
            subtitle: Text(
              "Total: ${(cart.amount * cart.quantity)}",
            ),
            trailing: Text(
              "${cart.quantity} x",
            ),
          ),
        ),
      ),
    );
  }
}
