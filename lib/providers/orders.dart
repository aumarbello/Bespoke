import 'dart:convert';

import 'package:bespoke/models/cart_item.dart';
import 'package:bespoke/models/order_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSaveOrders() async {
    final url = "https://bespoke-a3afd.firebaseio.com/orders/$userId.json?auth=$token";
    final response = await http.get(url);
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData == null) {
      return;
    }

    _orders.clear();
    responseData.forEach((orderId, orderData) {
      _orders.add(OrderItem(
          id: orderId,
          amount: orderData["amount"],
          orderTime: DateTime.parse(orderData["time"]),
          products: (orderData["products"] as List<dynamic>)
              .map((item) => CartItem(
                    item["id"],
                    item["title"],
                    item["amount"],
                    item["quantity"],
                  ))
              .toList()));
    });
    _orders = _orders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
    List<CartItem> products,
    double amount,
  ) async {
    final time = DateTime.now();
    final url = "https://bespoke-a3afd.firebaseio.com/orders/$userId.json?auth=$token";

    final response = await http.post(url,
        body: encodeOrderItem(
          products,
          amount,
          time,
        ));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: amount,
          products: products,
          orderTime: time,
        ));

    notifyListeners();
  }

  String encodeOrderItem(List<CartItem> items, double amount, DateTime time) {
    return json.encode({
      "products": items
          .map((item) => {
                "id": item.id,
                "title": item.title,
                "quantity": item.quantity,
                "amount": item.amount
              })
          .toList(),
      "amount": amount,
      "time": time.toIso8601String()
    });
  }
}
