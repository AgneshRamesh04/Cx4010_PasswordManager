import 'package:flutter/material.dart';
import 'package:PasswordManager/Controls/passwords_control.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PasswordManager/Widgets/buttons.dart';
import 'package:PasswordManager/screens/login_screen.dart';
import 'package:PasswordManager/screens/passwords_screen.dart';

import 'add_password_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static String id = "MainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Center(
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:  [
              Text('Password Manager',
                style: GoogleFonts.mPlus1p(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 25,),
              IconButton(
                onPressed: (){
                  Navigator.popUntil(context, ModalRoute.withName(LoginScreen.id));
                },
                icon: const Icon(Icons.logout)
              )
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.lightBlue.shade200,
                Colors.indigoAccent.shade200,
              ]
            )
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5.0),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
              ),
              SizedBox(
                width: 250.0,
                child: Center(
                  child: Text("Welcome",
                    style : GoogleFonts.aBeeZee(
                      fontSize: 30.0,
                      color: const Color(0xFF3B3F41),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(40.0),
              ),
              SimpleButton(
                onPress: (){
                  Navigator.pushNamed(context, PasswordsScreen.id);
                },
                content: "View Passwords",
                height: 80,
                width: 250,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
              ),
              SimpleButton(
                onPress: (){
                  Navigator.pushNamed(context, AddPasswordScreen.id, arguments: []);
                },
                content: "Add Password",
                height: 80,
                width: 250,
              ),
            ],
          ),
        )
      ),
    );
  }
}
