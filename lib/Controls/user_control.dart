import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:PasswordManager/Controls/passwords_control.dart';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';


import '../connection_ip.dart';

class UserMgr {
  static String username = "";
  static int userId = 0;
  static var publicKey;
  static List websites = [];


  /// Verifies credentials entered by user.
  static Future<bool> verifyCredentials(
     String enteredUsername, String enteredPassword) async {

    final message = utf8.encode(enteredPassword);

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 128,
    );

    // Password we want to hash
    final secretKey = SecretKey(message);

    // A random salt
    final nonce = [4,5,6];

    // Calculate a hash that can be stored in the database
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: nonce,
    );
    final newSecretKeyBytes = await newSecretKey.extractBytes();
    print('Result: $newSecretKeyBytes');

    final passwordCT = base64.encode(newSecretKeyBytes);
    final passwordCT_encoded = Uri.encodeComponent(passwordCT);

      String urlStr = connectionIP + 'verify?username=$enteredUsername&password=$passwordCT_encoded';
      var url = Uri.parse(urlStr);

      final response = await http.get(url);
      final result = json.decode(response.body) as Map<String, dynamic>;

      print(result);

      if(result['verification'] == true){
        username = result['username'];
        userId = result['id'];
        publicKey = result['public_key'];
        websites = await PasswordMgr.getWebsites();
        return true;
      }
      return false;
  }

  static addUser(String enteredUsername, String enteredPassword) async{

    final message = utf8.encode(enteredPassword);

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 128,
    );

    // Password we want to hash
    final secretKey = SecretKey(message);

    // A random salt
    final nonce = [4,5,6];

    // Calculate a hash that can be stored in the database
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: nonce,
    );
    final newSecretKeyBytes = await newSecretKey.extractBytes();
    print('Result: $newSecretKeyBytes');

    final passwordCT = base64.encode(newSecretKeyBytes);
    final passwordCT_encoded = Uri.encodeComponent(passwordCT);

    String urlStr = connectionIP + 'addUser?username=$enteredUsername&password=$passwordCT_encoded';

    var url = Uri.parse(urlStr);

    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    return result["Status"];
  }

  static rsa_decrypt(var passwordCT) async{
    print(passwordCT);

    final parser = RSAKeyParser();
    final _loadedData = await rootBundle.loadString("assets/keys/${UserMgr.username}_private.pem");
    print('_loadedData');
    final privKey =  parser.parse(_loadedData) as RSAPrivateKey;
    print('privKey');
    final pubKey =  parser.parse(UserMgr.publicKey) as RSAPublicKey;
    print('pubKey');

    final encrypter = Encrypter(RSA(publicKey: pubKey, privateKey: privKey));
    print('encrypter');
    final CT = Encrypted.fromBase64(passwordCT);
    print('CT');


    final decrypted = encrypter.decrypt(CT);
    print('decrypted');

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit

    return(decrypted);

  }

  static rsa_encrypt(String password) async{
    final parser = RSAKeyParser();
    print(password);
    print(UserMgr.username);

    final _loadedData = await rootBundle.loadString("assets/keys/${UserMgr.username}_private.pem");
    print('loadedDAta');
    final privKey =  parser.parse(_loadedData) as RSAPrivateKey;
    print('privKey');
    final pubKey =  parser.parse(UserMgr.publicKey) as RSAPublicKey;
    print('pubKey');

    //print(pubKey);
    //const plainText = 'trail test text';
    final encrypter = Encrypter(RSA(publicKey: pubKey, privateKey: privKey));
    print('encrypter');

    final encrypted = encrypter.encrypt(password);
    print('encrypted');

    print((encrypted.base64).runtimeType); //string
    //final decrypted = encrypter.decrypt(ct1);
    return (encrypted.base64); //String
  }

  static signature(String password) async{
    final algorithm = Ed25519();

    // Generate a key pair
    final keyPair = await algorithm.newKeyPair();

    // Sign a message
    final message = base64Url.decode(password); //convert to bytes
    final signature = await algorithm.sign(message, keyPair: keyPair);

    print(keyPair);
    print(keyPair.runtimeType);
//    print(keyPair.extractPublicKey().);
    print(keyPair.extractPrivateKeyBytes());
    print(keyPair.extractPublicKey());
    print(keyPair.extractPrivateKeyBytes());

    final public_key = keyPair.extractPublicKey();
    print(public_key);
    print(keyPair.extractPublicKey().runtimeType);
    print(keyPair.extractPrivateKeyBytes().runtimeType);

//    final public_key = keyPair.extractPublicKey();

//    print(utf8.decode(signature.bytes));

    print(signature);
    print('signature');
    print(signature.runtimeType);
    print('signature.runtimeType');

    print(signature.bytes);
    print('signature');


    print('Signature bytes: ${signature.bytes}');
    print('Public key: ${signature.publicKey}');


    final signatature_string = base64Url.encode(signature.bytes);
//    final public_key_string = base64Url.encode(signature.publicKey ;
    final public_key_string = base64Url.encode(signature.bytes);


    print(base64Url.encode(signature.bytes).runtimeType);
//    print(base64Url.encode(signature).runtimeType);


    // Anyone can verify the signature
    final isSignatureCorrect = await algorithm.verify(
      message,
      signature: signature,
    );

    print(isSignatureCorrect);

    return [signatature_string, public_key_string];
  }

  static verify(String retrived_password, String server_signature, String server_public_key) async{
    print('verify');

    final algorithm = Ed25519();


    final signature_bytes = base64.decode(server_signature);
    print(server_signature);
    print(signature_bytes);

    print('signature_bytes');

    final public_key_bytes = SimplePublicKey(base64.decode(server_public_key), type: KeyPairType.ed25519);
    print(server_public_key);

    print('public_key_bytes');
    final signature = Signature(signature_bytes, publicKey: public_key_bytes);
    print(signature);

    print(base64.decode(retrived_password));

    print('signature');
    // Anyone can verify the signature
    final isSignatureCorrect = await algorithm.verify(
      base64.decode(retrived_password),
      signature: signature,
    );

    print('isSignatureCorrect');
    print(isSignatureCorrect);

    return isSignatureCorrect;
  }
}