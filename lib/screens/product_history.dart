import 'package:bespoke/providers/product.dart';
import 'package:bespoke/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_details_screen.dart';

class ProductHistoryScreen extends StatefulWidget {
  @override
  _ProductHistoryScreenState createState() => _ProductHistoryScreenState();
}

class _ProductHistoryScreenState extends State<ProductHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchasing History"),
      ),
      body: FutureBuilder(
        future: Provider.of<Products>(context).fetchPurchasingHistory(),
        builder: (ctx, snapshot) {
          final List<Product> products = snapshot.data;
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return ListTile(
                      onTap: () => Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: product.id,
                      ),
                      leading: Hero(
                        tag: product.id,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(product.imageUrl),
                        ),
                      ),
                      title: Text(product.title),
                      subtitle: Text(product.description),
                    );
                  },
                  itemCount: products.length,
                );
        },
      ),
    );
  }
}
