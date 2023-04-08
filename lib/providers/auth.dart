import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_execption.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  final String webkey = 'AIzaSyDOWMeAeCvsMv51GU-N3iMLcZv3ilIqZkQ';

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
    } catch (error) {
      rethrow;
    }
  }
}
