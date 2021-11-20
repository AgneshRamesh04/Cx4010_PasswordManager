import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/Controls/passwords_control.dart';
import 'package:test_project/Controls/user_control.dart';
import 'package:test_project/Widgets/card_widget.dart';
import 'package:test_project/Widgets/popup_screen.dart';

import '../constants.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({Key? key}) : super(key: key);

  static String id = "PasswordsScreen";
  @override
  _PasswordsScreenState createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  var websitesData = UserMgr.websites;
  List<Widget> buildPasswordCards(List websites) {
    List<PasswordCard> passwordWebsites =[];
    if (websites.isNotEmpty) {
       for (List Web in websites) {
          passwordWebsites.add(
          PasswordCard(
              website: Web[0],
              username: Web[1],
              description: Web[2],
              popup: ()async {
                List Password = await PasswordMgr.getPassword(Web);
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return PopupScreen(pass: Password);
                  },
                );
                setState(() {
                  websitesData = UserMgr.websites;
                });
              }
          )
        );
      }
       return passwordWebsites;
    } else {
      return [
        const SizedBox(
          height: 100,
        ),
        Icon(
          Icons.star,
          color: Colors.grey[300],
          size: 80,
        ),
        Text(
          'No Passwords Yet',
          style: TextStyle(
            fontSize: 25,
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Row(
          children: [
            const SizedBox(width: 20,),
            Text('Password Manager',
              style: GoogleFonts.mPlus1p(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
      ),
      body : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 5.0,
              ),
              child: Text(
                "Saved Passwords",
                style : GoogleFonts.aBeeZee(
                  fontSize: 25.0,
                  color: const Color(0xFF3B3F41),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
              indent: 70,
              endIndent: 70,
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: buildPasswordCards(websitesData),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
