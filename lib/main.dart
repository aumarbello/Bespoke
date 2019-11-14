
import 'package:bespoke/helpers/CustomRoute.dart';
import 'package:bespoke/screens/botton_nav_screen.dart';
import 'package:bespoke/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/order_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_product_screen.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, oldProducts) {
            return Products(
              auth.token,
              auth.userId,
              oldProducts == null ? [] : oldProducts.items,
            );
          },
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (_, auth, oldOrders) => Orders(
            auth.token,
            auth.userId,
            oldOrders == null ? [] : oldOrders.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) {
          return MaterialApp(
            title: "Bespoke",
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato",
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android : CustomPageTransition(),
                TargetPlatform.iOS : CustomPageTransition(),
              })
            ),
            home: authData.isAuthenticated
                ? BottomNavigationScreen()
                : FutureBuilder(
                    future: authData.attemptAutoLogin(),
                    builder: (context, state) {
                      return state.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen();
                    },
                  ),
            routes: {
              SearchScreen.routeName: (_) => SearchScreen(),
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
//              ProductDetailScreen.routeName: (_) => ColaProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrderScreen.routeName: (_) => OrderScreen(),
              UserProductScreen.routeName: (_) => UserProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen()
            },
          );
        },
      ),
    );
  }
}
