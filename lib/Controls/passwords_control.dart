import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_project/Controls/user_control.dart';

import '../constants.dart';

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
    String urlStr = connectionIP + 'getPassword/$pass';
    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

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

    String urlStr = connectionIP + 'addPassword?website=$enteredWebsite&username=$enteredUsername&'
        'password=$enteredPassword&desp=$enteredDescription&userId=${UserMgr.userId}';
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

    String urlStr = connectionIP + 'addPassword?website=$website&username=$username&'
        'password=$enteredPassword&desp=$enteredDescription&userId=${UserMgr.userId}';

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