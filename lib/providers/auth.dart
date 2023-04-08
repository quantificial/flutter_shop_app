import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> signup(String email, String password) async {
    // https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=[API_KEY]
    // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
    // AIzaSyDOWMeAeCvsMv51GU-N3iMLcZv3ilIqZkQ

    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDOWMeAeCvsMv51GU-N3iMLcZv3ilIqZkQ';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    print(jsonDecode(response.body));
  }
}
