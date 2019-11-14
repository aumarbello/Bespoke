import 'package:bespoke/models/cart_item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.values.forEach((item) => total += (item.quantity * item.amount));

    return total;
  }

  void addProduct(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currentItem) => CartItem(
          DateTime.now().toString(),
          title,
          price,
          currentItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(DateTime.now().toString(), title, price, 1),
      );
    }

    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.remove(productId);

    notifyListeners();
  }

  void clear() {
    _items.clear();

    notifyListeners();
  }

  void removeSingleProduct(String id) {
    if (!_items.containsKey(id)) {
      return;
    }

    if (items[id].quantity > 1) {
      _items.update(id, (existingItem) {
        return CartItem(
          existingItem.id,
          existingItem.title,
          existingItem.amount,
          existingItem.quantity - 1,
        );
      });
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }
}
