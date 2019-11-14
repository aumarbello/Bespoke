import 'dart:convert';

import 'package:bespoke/models/http_exception.dart';
import 'package:bespoke/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String token;
  final String userId;
  final List<Product> _items;
  final List<Product> _searchResults = [];

  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  List<Product> get searchResults {
    return [..._searchResults];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSaveData([bool filterByUser = false]) async {
    final String filterSubUrl =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        "https://bespoke-a3afd.firebaseio.com/products.json?auth=$token&$filterSubUrl";
    try {
      final response = await http.get(url);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }

      print(response.body);

      url =
          "https://bespoke-a3afd.firebaseio.com/userFavourites/$userId.json?auth=$token";
      final favResponse = await http.get(url);
      final Map<String, dynamic> favouriteData = json.decode(favResponse.body);

      _items.clear();
      responseData.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          price: productData["price"],
          isFavourite:
              favouriteData == null ? false : favouriteData[productId] ?? false,
        ));
      });

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void searchProducts(String query) async {
    final String queryUrl = 'orderBy="title"&equalTo="$query"';
    final url =
        "https://bespoke-a3afd.firebaseio.com/products.json?auth=$token&$queryUrl";

    _searchResults.clear();

    final response = await http.get(url);
    final Map<String, dynamic> responseMap = json.decode(response.body);

    print(response.body);

    responseMap.forEach(
      (productId, productData) {
        final product = Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          price: productData["price"],
        );

        _searchResults.add(product);
        _items.removeWhere((item) => item.id == product.id);
        _items.add(product);
      },
    );

    notifyListeners();
  }

  Future<void> insertOrUpdate(Product product) async {
    if (product.id == null) {
      final url =
          "https://bespoke-a3afd.firebaseio.com/products.json?auth=$token";
      final response = await http.post(
        url,
        body: encodeProduct(product),
      );
      final newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);

      _items.add(newProduct);
      notifyListeners();
    } else {
      final currentIndex = items.indexWhere((item) => item.id == product.id);
      if (currentIndex != -1) {
        final url =
            "https://bespoke-a3afd.firebaseio.com/products/${product.id}.json?auth=$token";
        await http.patch(url, body: encodeProduct(product));
        _items[currentIndex] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        "https://bespoke-a3afd.firebaseio.com/products/$productId.json?auth=$token";
    final existingProductIndex =
        _items.indexWhere((item) => item.id == productId);
    final existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    await http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();

        throw HttpException("Failed to delete product");
      } else {}
    });
  }

  String encodeProduct(Product product) {
    final productData = {
      "title": product.title,
      "description": product.description,
      "price": product.price,
      "imageUrl": product.imageUrl,
      "creatorId": userId,
    };

    if (product.id == null) {
      productData.putIfAbsent(
        "isFavourite",
        () => product.isFavourite,
      );
    }

    return json.encode(productData);
  }
}
