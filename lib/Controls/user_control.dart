import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt_io.dart';
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
        publicKey = result['public_key'];
        websites = await PasswordMgr.getWebsites();
        //await rsa(passwordCT);
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

  static rsa_decrypt(var passwordCT) async{
    final parser = RSAKeyParser();
    final _loadedData = await rootBundle.loadString("assets/keys/${UserMgr.username}_private.pem");
    final privKey =  parser.parse(_loadedData) as RSAPrivateKey;
    print(passwordCT);
    final pubKey =  parser.parse(UserMgr.publicKey) as RSAPublicKey;

    //print(pubKey);
    //const plainText = 'trail test text';
    final encrypter = Encrypter(RSA(publicKey: pubKey, privateKey: privKey));

    final CT = Encrypted.fromBase64(passwordCT);
    final ct1 = Encrypted.fromBase16(passwordCT);

    print(CT.base16);
    //final encrypted = encrypter.encrypt(plainText);
    final decrypted = encrypter.decrypt(ct1);

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    //print(encrypted.base64); // kO9EbgbrSwiq0EYz0aBdljHSC/rci2854Qa+nugbhKjidlezNplsEqOxR+pr1RtICZGAtv0YGevJBaRaHS17eHuj7GXo1CM3PR6pjGxrorcwR5Q7/bVEePESsimMbhHWF+AkDIX4v0CwKx9lgaTBgC8/yJKiLmQkyDCj64J3JSE=
    return decrypted;

    //print(data);
  }

  static rsa_encrypt(String password) async{
    final parser = RSAKeyParser();
    final _loadedData = await rootBundle.loadString("assets/keys/${UserMgr.username}_private.pem");
    final privKey =  parser.parse(_loadedData) as RSAPrivateKey;
    final pubKey =  parser.parse(UserMgr.publicKey) as RSAPublicKey;

    //print(pubKey);
    //const plainText = 'trail test text';
    final encrypter = Encrypter(RSA(publicKey: pubKey, privateKey: privKey));

    final encrypted = encrypter.encrypt(password);
    //final decrypted = encrypter.decrypt(ct1);

    print(encrypted.bytes); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    return encrypted.bytes; // kO9EbgbrSwiq0EYz0aBdljHSC/rci2854Qa+nugbhKjidlezNplsEqOxR+pr1RtICZGAtv0YGevJBaRaHS17eHuj7GXo1CM3PR6pjGxrorcwR5Q7/bVEePESsimMbhHWF+AkDIX4v0CwKx9lgaTBgC8/yJKiLmQkyDCj64J3JSE=
    //return decrypted;

    //print(data);
  }
}