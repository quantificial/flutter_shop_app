import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_execption.dart';
import 'package:shop_app/providers/auth.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  String? _authToken;

  var _showFavoritesOnly = false;

  Products(this._authToken, this._items);

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((element) => element.isFavorite == true).toList();
    }

    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    var url = Uri.parse(
        'https://flutter-update-88cf0-default-rtdb.firebaseio.com/products.json?auth=${_authToken}');
    try {
      final response = await http.get(url);
      print(response.body);

      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: (prodData['price'] as double),
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) {
    // http call to firebase
    final url = Uri.parse(
        'https://flutter-update-88cf0-default-rtdb.firebaseio.com/products.json?auth=${_authToken}');

    return http
        .post(url,
            body: jsonEncode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite
            }))
        .then((value) {
      // logic here.
      print(value.body);

      //_items.add(value)
      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          //id: DateTime.now().toString()
          id: jsonDecode(value.body)['name']);
      _items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw (error); // throw the error and handle in parent block
    });

    //return Future.value();
  }

  Future<void> updateProduct(String id, Product newProductData) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-update-88cf0-default-rtdb.firebaseio.com/products/${newProductData.id}.json?auth=${_authToken}');

      await http.patch(url,
          body: jsonEncode({
            'title': newProductData.title,
            'description': newProductData.description,
            'imageUrl': newProductData.imageUrl,
            'price': newProductData.price,
          }));

      _items[prodIndex] = newProductData;
      notifyListeners();
    } else {
      print('error, no such product');
    }
  }

  void deleteProduct(String id) {
    final url = Uri.parse(
        'https://flutter-update-88cf0-default-rtdb.firebaseio.com/products/${id}.json?auth=${_authToken}');

    // add some logic for erro handling
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    //_items.removeWhere((element) => element.id == id);
    _items.removeAt(existingProductIndex);
    notifyListeners();

    http
        .delete(url)
        .then((value) => {
              //existingProduct = null;

// delete not successful, the return status is over 400
              if (value.statusCode >= 400)
                {throw HttpExeception('Could not delete product.')}
            })
        .catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
      print('cannot delete product');
      notifyListeners();
    });
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
