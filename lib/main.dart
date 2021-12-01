
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_num_auth_firebase/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
    );
  }
}

