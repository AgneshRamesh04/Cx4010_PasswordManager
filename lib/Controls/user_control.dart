import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_project/Controls/passwords_control.dart';

import '../constants.dart';

class UserMgr {
  static String username = "";
  static int userId = 0;
  static var privateKey;
  static var publicKey;
  static List websites = [];


  /// Verifies credentials entered by user.
  static Future<bool> verifyCredentials(
     String enteredUsername, String enteredPassword) async {

      final message = utf8.encode(enteredPassword);
      print(message);
      final algorithm = Sha256();
      final hash = await algorithm.hash(message);
      print(hash);
      final passwordCT = base64.encode(hash.bytes);

      String urlStr = connectionIP + 'verify?username=$enteredUsername&password=$passwordCT';
      var url = Uri.parse(urlStr);

      final response = await http.get(url);
      final result = json.decode(response.body) as Map<String, dynamic>;

      if(result['verification'] == true){
        username = result['username'];
        userId = result['id'];
        privateKey = result['pem'];
        publicKey = result['public_key'];
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

    //Map myUser = {"Username" : enteredUsername, "Password" : passwordCT};

    String urlStr = connectionIP + 'addUser?username=$enteredUsername&password=$passwordCT';

    print(urlStr);
    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    return result["Status"];
  }
}