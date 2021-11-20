
import 'package:flutter/material.dart';
import 'package:test_project/Controls/user_control.dart';

import 'package:test_project/Widgets/buttons.dart';
import 'package:test_project/screens/signup_screen.dart';
import 'forgot_password_screen.dart';
import 'main_screen.dart';

/// Unique Key for the form displayed on the screen
final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = "Login_Screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

String enteredUsername = "";
String enteredPassword = "'";

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _loading = false;
  String idk = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    body: Container(
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.lightBlue.shade200,
              Colors.indigoAccent.shade200,
            ],
          ),
        ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key : _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 7.5, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Username';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            enteredUsername = value;
                          },
                          cursorColor: Colors.white,//Colors.teal[900],
                          maxLength: 30,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 7.5, horizontal: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            enteredPassword = value;
                          },
                          obscureText: _obscureText,
                          cursorColor: Colors.white,
                          maxLength: 30,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.lock, color: Colors.black),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        )
                      ),
                      // FlatButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(
                      //         context, ForgotPasswordScreen.id);
                      //   },
                      //   child: const Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(color: Colors.white, fontSize: 15),
                      //   ),
                      // ),
                      const SizedBox(height: 10,),
                      LoginButton(
                        onPress: ()  async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            var k = await UserMgr.verifyCredentials(
                                enteredUsername, enteredPassword);
                            print(k);
                            if (k) {
                              setState(() {
                              _loading = false;
                              });
                              Navigator.pushNamed(context, MainScreen.id);
                            }
                            else {
                              setState(() {
                                _loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Wrong username or password. Please check your credentials and try again.")),
                              );
                            }
                          }
                        },
                        content: "Login",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15,),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.id);
                          },
                          child: const Text(
                            'New Here? Register!',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _loading ?
              const Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const SizedBox(),
          ],
        ),
      ),
      )
    );
  }
}
