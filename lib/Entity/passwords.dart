import 'package:flutter/cupertino.dart';

class Passwords {
  final String _username;
  final String _website;
  final String _description;
  final String _password;
  /// Named constructor to initialize fields of a password

  Passwords({
    required String username,
    required String website,
    required String description,
    String password = ""
  })  : _username = username,
        _website = website,
        _description = description,
        _password = password;

  String get username => _username;

  String get website => _website;

  String get description => _description;

  String get password => _password;


  /// Prints details of Waste POI (for debug)
  void printDetails() {
    print("Username: $_username");
    print("Website: $_website");
    print("Description: $_description");
    print("Password: $_password");
  }
}