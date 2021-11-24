import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:PasswordManager/Controls/passwords_control.dart';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

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
      final algorithm = Sha256();
      final hash = await algorithm.hash(message);
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
        await rsa(passwordCT);
        return true;
      }
      return false;
  }

  static addUser(String enteredUsername, String enteredPassword) async{

    final message = utf8.encode(enteredPassword);
    final algorithm = Sha256();
    final hash = await algorithm.hash(message);
    final passwordCT = base64.encode(hash.bytes);

    String urlStr = connectionIP + 'addUser?username=$enteredUsername&password=$passwordCT';

    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    return result["Status"];
  }

  static rsa(String password) async{

    //final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');   //We can use this if the private key is stored in a file

    final parser = RSAKeyParser();
    // the public key is retrieved and stored in a global variable when the user login
    final pubKey =  parser.parse(publicKey) as RSAPublicKey;
    print(pubKey);
    const plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';

    //final encrypter = Encrypter(RSA(publicKey: pubKey, privateKey: privKey));

    //final encrypted = encrypter.encrypt(plainText);
    //final decrypted = encrypter.decrypt(encrypted);

    //print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    //print(encrypted.base64); // kO9EbgbrSwiq0EYz0aBdljHSC/rci2854Qa+nugbhKjidlezNplsEqOxR+pr1RtICZGAtv0YGevJBaRaHS17eHuj7GXo1CM3PR6pjGxrorcwR5Q7/bVEePESsimMbhHWF+AkDIX4v0CwKx9lgaTBgC8/yJKiLmQkyDCj64J3JSE=


    //print(data);
  }
}