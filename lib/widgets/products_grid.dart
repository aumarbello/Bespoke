import 'package:bespoke/providers/products.dart';
import 'package:bespoke/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavouritesOnly;

  ProductsGrid(this.showFavouritesOnly);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Products>(context);
    final productList = showFavouritesOnly ? data.favouriteItems : data.items;

    return GridView.builder(
      padding: EdgeInsets.all(
        12,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (_, index) {
        return ChangeNotifierProvider.value(
          child: ProductItem(),
          value: productList[index],
        );
      },
      itemCount: productList.length,
    );
  }
}
