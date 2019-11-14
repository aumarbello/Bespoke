import 'dart:convert';

import 'package:bespoke/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite(String token, String userId) async {
    isFavourite = !isFavourite;
    notifyListeners();

    final url =
        "https://bespoke-a3afd.firebaseio.com/userFavourites/$userId/$id.json?auth=$token";

    try {
      final response = await http.put(url, body: json.encode(isFavourite));
      if(response.statusCode >= 400) {
        throw HttpException("Something went wrong");
      }
    } catch (error) {
      isFavourite = !isFavourite;
      notifyListeners();

      throw error;
    }
  }
}
