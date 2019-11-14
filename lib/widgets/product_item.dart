import 'package:bespoke/providers/auth.dart';
import 'package:bespoke/providers/cart.dart';
import 'package:bespoke/providers/product.dart';
import 'package:bespoke/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);

    final Product product = Provider.of(
      context,
      listen: false,
    );

    final Cart cart = Provider.of(
      context,
      listen: false,
    );

    final Auth auth = Provider.of(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(ProductDetailScreen.routeName, arguments: product.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          12,
        ),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (_, product, child) => IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () async {
                  try {
                    await product.toggleFavourite(auth.token, auth.userId);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    ));
                  }
                },
              ),
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addProduct(
                  product.id,
                  product.title,
                  product.price,
                );

                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Item added to cart"),
                  duration: Duration(seconds: 4),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => cart.removeSingleProduct(product.id),
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
