import 'package:bespoke/screens/order_screen.dart';
import 'package:bespoke/screens/product_overview_screen.dart';
import 'package:bespoke/screens/user_product_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final _pages = [
    {
      "title": "Home",
      "page": ProductOverviewScreen(),
      "icon": Icons.home,
    },
    {
      "title": "Orders",
      "page": OrderScreen(),
      "icon": Icons.payment,
    },
    {
      "title": "Manage Products",
      "page": UserProductScreen(),
      "icon": Icons.edit,
    }
  ];

  var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: _switchPage,
          currentIndex: _currentPage,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          items: _pages
              .map(
                (entry) => BottomNavigationBarItem(
                  title: Text(entry["title"]),
                  icon: Icon(entry["icon"]),
                ),
              )
              .toList(),
        ),
        body: _pages[_currentPage]["page"]);
  }

  void _switchPage(int selectedPage) {
    setState(() {
      _currentPage = selectedPage;
    });
  }
}
