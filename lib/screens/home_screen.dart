import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: const Text('Verified Phone-Number',
        style: TextStyle(
          color: Colors.black45,
          fontSize: 20.0,
        ),),
        actions: [
          IconButton (
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(context,MaterialPageRoute(
                builder: (context) =>LoginScreen()
              )
              );
            },
            icon: Icon(Icons.logout),
            color: Colors.black54,
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to Home Page',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black54,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
