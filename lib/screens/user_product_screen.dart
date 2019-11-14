import 'package:bespoke/providers/product.dart';
import 'package:bespoke/providers/products.dart';
import 'package:bespoke/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSaveData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (_, state) => state.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, products, _) => ListView.builder(
                    itemBuilder: (_, index) {
                      final Product product = products.items[index];
                      return UserProductItem(
                        product.id,
                        product.title,
                        product.imageUrl,
                      );
                    },
                    itemCount: products.items.length,
                  ),
                ),
              ),
      ),
    );
  }
}
