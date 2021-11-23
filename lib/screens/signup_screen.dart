import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/Controls/user_control.dart';
import 'package:test_project/Widgets/buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static String id = "SignUpScreen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

final _formKey = GlobalKey<FormState>();

class _SignUpScreenState extends State<SignUpScreen> {
  bool _loading = false;

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  var passwordtxtCntrl = TextEditingController();
  var repasswordtxtCntrl = TextEditingController();

  String enteredUsername = "";
  String enteredPassword = "";
  String enteredConfirmPassword = "";

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Sign Up",
                        style : GoogleFonts.aBeeZee(
                          fontSize: 27.0,
                          color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 65,),
                      SizedBox(
                        width: 75,
                        child: FlatButton(
                          padding: const EdgeInsets.all(2),
                          onPressed: (){
                            String generatedPassword = "it worksss";
                            enteredConfirmPassword = generatedPassword;
                            repasswordtxtCntrl.text = generatedPassword;
                            setState(() {
                              enteredPassword = generatedPassword;
                              passwordtxtCntrl.text = generatedPassword;
                            });
                          },
                          child: const Text(
                            "Generate Password",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black,
                              fontSize: 16 ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
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
                                  cursorColor: Colors.white,
                                  maxLength: 30,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.person, color: Colors.black),
                                    labelText: 'Username',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width:0.5,
                                          color: Colors.black
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width:0.5,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              child: TextFormField(
                                controller: passwordtxtCntrl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  else if (value.length < 6){
                                    return "Password must contain atleast 6 characters";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    enteredPassword = value;
                                  });
                                },
                                cursorColor: Colors.white,
                                maxLength: 30,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.lock, color: Colors.black),
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width:0.5,
                                        color: Colors.black
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width:0.5,
                                        color: Colors.black
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            enteredPassword.isNotEmpty ?
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 0, left: 58, right: 100, bottom: 10),
                                child: FlutterPasswordStrength(
                                  backgroundColor: Colors.white,
                                  password: enteredPassword,
                                  strengthCallback: (strength){
                                    debugPrint(strength.toString());
                                  },
                                  height: 10,
                                  radius: 5,
                                ),
                              ):
                              SizedBox(),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              child: TextFormField(
                                controller: repasswordtxtCntrl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Confirm Password";
                                  }
                                  if (value != enteredPassword) {
                                    return "Passwords Don't Match";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  enteredConfirmPassword = value;
                                },
                                cursorColor: Colors.white,
                                maxLength: 30,
                                obscureText: _obscureConfirmText,
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.lock, color: Colors.black),
                                  labelText: 'Confirm Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width:0.5,
                                        color: Colors.black
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width:0.5,
                                        color: Colors.black
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmText = !_obscureConfirmText;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureConfirmText ?
                                      Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            LoginButton(
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  String status = await UserMgr.addUser(enteredUsername, enteredPassword);
                                  if (status == "Registered"){
                                    setState(() {
                                      _loading = false;
                                    });
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return const AlertDialog(
                                          title: Text("Success"),
                                          content: Text(
                                              "You have successfully registered!! Login to continue."),
                                        );
                                      },
                                    );
                                  }
                                  else if (status == "Username Exists"){
                                    setState(() {
                                      _loading = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return const AlertDialog(
                                          title: Center(child: Text("Username Exists")),
                                          content: Text(
                                              'Sorry!! The entered Username is not available.'),
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    setState(() {
                                      _loading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(content: Text('Error')),
                                    );
                                  }
                                }
                              },
                              content: "Register"
                            ),
                          ],
                        ),
                      ),
                    ),
                    _loading ?
                    const Padding(
                      padding: EdgeInsets.only(top : 200.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
