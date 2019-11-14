import 'package:bespoke/models/cart_item.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final DateTime orderTime;
  final double amount;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.orderTime,
    @required this.products,
  });
}
