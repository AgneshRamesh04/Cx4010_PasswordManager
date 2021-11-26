import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PasswordManager/Controls/passwords_control.dart';
import 'package:PasswordManager/Widgets/buttons.dart';
import 'package:PasswordManager/screens/main_screen.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({Key? key}) : super(key: key);

  static String id = "AddPasswordScreen";
  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

final _formKey = GlobalKey<FormState>();

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  bool _loading = false;

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  var passwordtxtCntrl = TextEditingController();
  var repasswordtxtCntrl = TextEditingController();

  bool strongPassword = false;

  String enteredWebsite = "";
  String enteredUsername = "";
  String enteredPassword = "";
  String enteredConfirmPassword = "";
  String enteredDescription = " ";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    String heading = "";
    bool edit = false;

    if (args.isEmpty) {
      heading = "Add Password";
    }
    else{
      heading = "Edit Password";
      edit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title : Row(
          children: [
            const SizedBox(width: 20,),
            Text('Password Manager',
                style: GoogleFonts.mPlus1p(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                )
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
      body: SafeArea(
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
                      heading,
                      style : GoogleFonts.aBeeZee(
                        fontSize: 25.0,
                        color: const Color(0xFF3B3F41),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 50,),
                    SizedBox(
                      width: 70,
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: TextFormField(
                              enabled: !edit,
                              initialValue: edit ? args[1]:null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Website Name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                enteredWebsite = value;
                              },
                              cursorColor: Colors.white,
                              maxLength: 30,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.web, color: Color(0xFF3B3F41)),
                                labelText: 'Website Name',
                                labelStyle: TextStyle(
                                  color: Color(0xFF3B3F41),
                                  fontSize: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                              ),
                            )
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: TextFormField(
                              enabled: !edit,
                              initialValue: edit ? args[2]:null,
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
                                icon: Icon(Icons.person, color: Color(0xFF3B3F41)),
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: Color(0xFF3B3F41),
                                  fontSize: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
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
                                icon: const Icon(Icons.lock, color: Color(0xFF3B3F41)),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF3B3F41),
                                  fontSize: 18,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
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
                                      color: const Color(0xFF3B3F41)
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
                                backgroundColor: Colors.lightBlue.shade200,
                                password: enteredPassword,
                                strengthCallback: (strength){
                                  if(strength>=0.5){
                                    strongPassword = true;
                                  }
                                  debugPrint(strength.toString());
                                },
                                height: 10,
                                radius: 5,
                              ),
                            ):
                            const SizedBox(),
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
                                icon: const Icon(Icons.lock, color: Color(0xFF3B3F41)),
                                labelText: 'Confirm Password',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF3B3F41),
                                  fontSize: 18,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
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
                                    color: const Color(0xFF3B3F41),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: TextFormField(
                              initialValue: edit ? args[5]:null,
                              onChanged: (value) {
                                enteredDescription = value;
                              },
                              cursorColor: Colors.white,
                              maxLength: 30,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.note, color: Color(0xFF3B3F41)),
                                labelText: 'Description',
                                helperText: "Enter description for the password",
                                labelStyle: TextStyle(
                                  color: Color(0xFF3B3F41),
                                  fontSize: 18,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width:0.5,
                                      color: Color(0xFF3B3F41)
                                  ),
                                ),
                              ),
                            )
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          SimpleButton(
                            height: 65,
                            width: 200,
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                if (!strongPassword){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return const AlertDialog(
                                        title: Text("Weak Password"),
                                        content: Text(
                                            "Please enter a stronger password."),
                                      );
                                    },
                                  );
                                  return;
                                }
                                setState(() {
                                  _loading = true;
                                });
                                if (edit){
                                  bool status = await PasswordMgr.editPassword(
                                      args[1], args[2], enteredPassword, enteredDescription);
                                  if (status) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Navigator.popUntil(context, ModalRoute.withName(MainScreen.id));
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return const AlertDialog(
                                          title: Text("Success"),
                                          content: Text("Your password was successfully edited!!"),
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    setState(() {
                                      _loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error')),
                                    );
                                  }
                                }
                                else {
                                  String status = await PasswordMgr.addPassword(
                                      enteredWebsite, enteredUsername,
                                      enteredPassword, enteredDescription);
                                  if (status == "Added"){
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
                                              "Your password was successfully added!!"),
                                        );
                                      },
                                    );
                                  }
                                  else if (status == "Password Exists"){
                                    setState(() {
                                      _loading = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return const AlertDialog(
                                          title: Text("Password Detected"),
                                          content: Text(
                                              "You already have a password saved for the entered website and username."),
                                        );
                                      },
                                    );
                                  }
                                  else{
                                    setState(() {
                                      _loading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(content: Text('Error')),
                                    );
                                  }
                                }
                              }
                            },
                            content: heading
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
    );
  }
}
