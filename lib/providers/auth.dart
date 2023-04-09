import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_execption.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  final String webkey = 'AIzaSyDOWMeAeCvsMv51GU-N3iMLcZv3ilIqZkQ';

  bool get isAuth {
    if (_expiryDate != null && _token != null) {
      if (_expiryDate!.isAfter(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  String get token {
    if (_expiryDate != null && _token != null) {
      if (_expiryDate!.isAfter(DateTime.now())) {
        return _token!;
      }
    }
    return '';
  }

  String get userId {
    if (_userId != null) {
      return _userId!;
    } else {
      return '';
    }
  }

  Future<void> signup(String email, String password) async {
    // https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=[API_KEY]
    // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
    // AIzaSyDOWMeAeCvsMv51GU-N3iMLcZv3ilIqZkQ

    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${webkey}';

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      print(jsonDecode(response.body));

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpExeception(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${webkey}';

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      print(jsonDecode(response.body));

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpExeception(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
