import 'package:bespoke/providers/auth.dart';
import 'package:bespoke/providers/cart.dart';
import 'package:bespoke/providers/products.dart';
import 'package:bespoke/screens/cart_screen.dart';
import 'package:bespoke/screens/search_screen.dart';
import 'package:bespoke/widgets/badge.dart';
import 'package:bespoke/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MenuOptions { Favourites, All, LogOut }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavourites = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();

    isLoading = true;
    Provider.of<Products>(context, listen: false).fetchAndSaveData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bespoke",
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (
              _,
              cart,
              child,
            ) {
              return Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SearchScreen.routeName);
                    },
                  ),
                  Badge(
                    child: child,
                    value: cart.itemCount.toString(),
                  ),
                  PopupMenuButton(
                    onSelected: (MenuOptions selectedOption) async {
                      if(selectedOption == MenuOptions.LogOut) {
                        await Provider.of<Auth>(context).logOut();
                      } else {
                        setState(() {
                          showOnlyFavourites =
                              selectedOption == MenuOptions.Favourites;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          "Favourites",
                        ),
                        value: MenuOptions.Favourites,
                      ),
                      PopupMenuItem(
                        child: Text(
                          "All",
                        ),
                        value: MenuOptions.All,
                      ),
                      PopupMenuItem(
                        child: Text(
                          "Log out",
                        ),
                        value: MenuOptions.LogOut,
                      ),

                    ],
                  ),

                ],
              );
            },
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                CartScreen.routeName,
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFavourites),
    );
  }
}
