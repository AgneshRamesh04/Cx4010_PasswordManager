import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_project/Controls/passwords_control.dart';

import '../constants.dart';

class UserMgr {
  static String username = "";
  static int userId = 0;
  static String secret1 = "";
  static String secret = "";
  static List websites = [];


  /// Verifies credentials entered by user.
  static Future<bool> verifyCredentials(
     String enterUsername, String enteredPassword) async {

      final message = utf8.encode(enteredPassword);
      final algorithm = Sha256();
      final hash = await algorithm.hash(message);
      final passwordCT = base64.encode(hash.bytes);
      print(passwordCT);

      String urlStr = connectionIP + 'verify/$enterUsername/$passwordCT';
      var url = Uri.parse(urlStr);

      final response = await http.get(url);
      final result = json.decode(response.body) as Map<String, dynamic>;

      if(result['verification'] == true){
        username = result["username"];
        userId = result['id'];
        secret1 = result['secret1'];
        secret = result['secret'];
        websites = await PasswordMgr.getWebsites();
        return true;
      }
      return false;
  }

  static addUser(String enteredUsername, String enteredPassword) async{

    final message = utf8.encode(enteredPassword);
    final algorithm = Sha256();
    final hash = await algorithm.hash(message);
    final passwordCT = base64.encode(hash.bytes);
    print(passwordCT);

    String urlStr = connectionIP + 'addUser/$enteredUsername/$passwordCT';

    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    return result["Status"];
  }
}