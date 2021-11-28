import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:PasswordManager/Controls/user_control.dart';

import '../connection_ip.dart';
import 'dart:math';

class PasswordMgr {
  /// Verifies credentials entered by user.
  static Future<List> getWebsites() async {

    String urlStr = connectionIP + 'getWebsites/${UserMgr.userId}';
    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    return result["Websites"];
  }

  static Future<List> getPassword(List pass) async {
    String urlStr = connectionIP + 'getPassword/$pass/${UserMgr.userId}';
    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    print(result);
    //server sends back a response, we need to verify
    final isResultVerified = await UserMgr.verify(result["Password"][3], result["Password"][7], result["Password"][8]);

    print('Verification Results------');
    print(isResultVerified);

    print(result["Password"]);
    print(result["Password"][3]);
    print(result["Password"].runtimeType);

    var plaintext_pw = await UserMgr.rsa_decrypt(result["Password"][3]);
    print(plaintext_pw);

    result["Password"][3] = plaintext_pw;

    return result["Password"];
  }

  static deletePassword(List pass) async{
    int passId = pass[0];
    pass.removeAt(0);
    pass.removeAt(2);
    pass.removeAt(3);

    String urlStr =  connectionIP + 'deletePassword/$passId';
    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    if(result["Status"] == "Deleted"){
      UserMgr.websites.removeWhere((item) => item[0] == pass[0] && item[1] == pass[1]);
    }
  }

  static addPassword(String enteredWebsite, String enteredUsername,
      String enteredPassword, String enteredDescription) async{

    final CT = await UserMgr.rsa_encrypt(enteredPassword);
    final ct_encoded = Uri.encodeComponent(CT); //message

    //Sign a message that the server needs to verify
    final List<String> signing = await UserMgr.signature(CT);
//    final signed_encoded = Uri.encodeComponent(CT); //message

    print('signed');
    print(UserMgr.userId);

    final signature = signing[0];
    final public_key = signing[1];

    print(signature);
    print(public_key);
    String urlStr = connectionIP + 'addPassword?website=$enteredWebsite&username=$enteredUsername&'
      'password=$ct_encoded&desp=$enteredDescription&userId=${UserMgr.userId}&'
      'sign=$signature&publickey=$public_key';

    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;
    if(result["Status"] == "Added"){
      UserMgr.websites.add([enteredWebsite,enteredUsername,enteredDescription]);
    }
    return result["Status"];
  }



  static editPassword(String website, String username,
      String enteredPassword, String enteredDescription) async{

    final CT = await UserMgr.rsa_encrypt(enteredPassword);
    final ct_encoded = Uri.encodeComponent(CT);

    String urlStr = connectionIP + 'editPassword?website=$website&username=$username&'
        'password=$ct_encoded&desp=$enteredDescription&userId=${UserMgr.userId}';

    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;
    if (result["Status"] == "Edited"){
      UserMgr.websites.removeWhere((item) => item[0] == website && item[1] == username);
      UserMgr.websites.add([website,username,enteredDescription]);
      return true;
    }
    else{
      return false;
    }
  }

}

class Utils {
  static final Random _random = Random.secure();

  static String CreateCryptoRandomString([int length = 12]) {
    var char_list =  'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*(),.?":{}|<>';
    var values = List<int>.generate(length, (i) => _random.nextInt(char_list.length));

    String password = '';
    for(var i = 0; i<values.length; i++){
      password += char_list[values[i]];
    }

    print(password);

    if (password == null || password.isEmpty) {
      print('false');
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > 6;

    print(hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength);

    return password;
//    return base64Url.encode(values);
  }

  static bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
  }

}