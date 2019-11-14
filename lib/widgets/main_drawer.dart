import 'package:bespoke/providers/auth.dart';
import 'package:bespoke/screens/order_screen.dart';
import 'package:bespoke/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              "Bespoke",
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text(
              "Orders",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: Text(
              "Manage Products",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text(
              "Log out",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();

              Provider.of<Auth>(context).logOut();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
