import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  // void toggleFavoriteStatus() {
  //   this.isFavorite = !this.isFavorite;
  //   notifyListeners();
  // }

  void _setFavValue(bool v) {
    isFavorite = v;
  }

  void toggleFavoriteStatus(String tokenId, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://flutter-update-88cf0-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$tokenId';

    print(url);

    try {
      // final response = await http.patch(
      //   Uri.parse(url),
      //   body: jsonEncode({
      //     'isFavorite': isFavorite,
      //   }),
      // );
      print(jsonEncode(isFavorite));
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
