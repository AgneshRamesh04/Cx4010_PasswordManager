import 'package:flutter/material.dart';
import 'package:test_project/screens/add_password_screen.dart';
import 'package:test_project/screens/forgot_password_screen.dart';
import 'package:test_project/screens/login_screen.dart';
import 'package:test_project/screens/main_screen.dart';
import 'package:test_project/screens/passwords_screen.dart';
import 'package:test_project/screens/signup_screen.dart';

void main()  {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData.light(),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
        MainScreen.id: (context) => const MainScreen(),
        PasswordsScreen.id: (context) => const PasswordsScreen(),
        AddPasswordScreen.id: (context) => const AddPasswordScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
      },
    );
  }
}