
import 'package:flutter/material.dart';
import 'package:PasswordManager/Controls/passwords_control.dart';
import 'package:PasswordManager/screens/add_password_screen.dart';
import 'package:flutter/services.dart';

class PopupScreen extends StatelessWidget {

  final List pass;

  const PopupScreen({
    Key? key,
    required this.pass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pass[1],
      child: SafeArea(
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ),
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 60.00,
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      pass[1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: 'DancingScript',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 68,),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height : 15),
                Text(
                  "Username: " + pass[2],
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                    fontFamily: 'DancingScript',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pass[5],
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                    fontFamily: 'DancingScript',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Password: "),
                        Text(pass[3]),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: pass[3]));
                          },
                          icon: const Icon(Icons.copy))
                      ],
                    ),
                  ),
                )
              ]
            ),
          ),
          actions: <Widget>[
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                    onPressed:() async{
                      Navigator.pushNamed(context, AddPasswordScreen.id, arguments: pass);
                    },
                    color : const Color(0xFF66B9C1),
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                  const SizedBox(width: 20,),
                  RaisedButton.icon(
                    onPressed:() async{
                      bool confirm = false;
                      await showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Center(child: Text("Delete Password")),
                            content: Text("Do you wish to delete the saved password for ${pass[1]}"),
                            actions: [
                              FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                              FlatButton(
                                onPressed: (){
                                  confirm = true;
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes"),
                              )
                            ],
                          );
                        },
                      );
                      if (confirm){
                        await PasswordMgr.deletePassword(pass);
                        Navigator.of(context).pop();
                      }
                    },
                    color : const Color(0xFFC16666),
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}