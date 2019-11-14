import 'dart:async';
import 'dart:convert';

import 'package:bespoke/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  static const _userData = "userData";

  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  Timer _timer;

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _userId != null &&
        _tokenExpiryDate.isAfter(
          DateTime.now(),
        )) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> _authenticate(
    String email,
    String password,
    String path,
  ) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$path?key=AIzaSyDqLUlmzgJZZ4ijrW-QjD_XS5RT4_L6vU0";

    final response = await http.post(
      url,
      body: json.encode(
        {"email": email, "password": password, "returnSecureToken": true},
      ),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode >= 400) {
      final Map<String, dynamic> errors = responseData["error"];

      var message = "An error occured";
      switch (errors["message"]) {
        case "EMAIL_EXISTS":
          message = "Email address already in use";
          break;
        case "EMAIL_NOT_FOUND":
          message = "User with email address not found";
          break;
        case "INVALID_PASSWORD":
          message = "Invalid password entered";
          break;
        case "USER_DISABLED":
          message = "User registered with this email address has been disabled";
          break;
      }

      throw HttpException(message);
    } else {
      _userId = responseData["localId"];
      _token = responseData["idToken"];
      _tokenExpiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );

      final preferences = await SharedPreferences.getInstance();
      preferences.setString(
          _userData,
          json.encode({
            "userId": _userId,
            "token": _token,
            "expiryDate": _tokenExpiryDate.toIso8601String(),
          }));
      _autoLogOut();
      notifyListeners();
    }
  }

  Future<bool> attemptAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if(!preferences.containsKey(_userData)){
      return false;
    }


    final userData = json.decode(preferences.getString(_userData));
    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _userId = userData["userId"];
    _token = userData["token"];
    _tokenExpiryDate = expiryDate;

    _autoLogOut();

    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    _token = _userId = null;
    _tokenExpiryDate = null;

    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }

    notifyListeners();
  }

  void _autoLogOut() {
    if (_timer != null) {
      _timer.cancel();
    }

    final timeToExpiry = _tokenExpiryDate.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
