import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";


import 'home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        const Text('Phone-Number Verification',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 30.0
          ),),
        const Spacer(),

        const SizedBox(height: 30.0),
        Container(
          padding: const EdgeInsets.only(left: 15.0,top: 5.0),
          height: 60.0,
          width: MediaQuery.of(context).size.width-40,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                spreadRadius: 3.0,
                color: Colors.grey.withOpacity(0.2)
              )
            ]
          ),
          child:  TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Phone Number",
            ),
          ),
        ),

        const SizedBox(height: 25.0),
        InkWell(
          onTap: () async {
            setState(() {
              showLoading = true;
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                //signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                _scaffoldKey.currentState!.showSnackBar(
                    SnackBar(content: Text(verificationFailed.message.toString())));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
            setState(() {
              phoneController.clear();
            });
          },
          child: Container(
            height: 60.0,
            width: MediaQuery.of(context).size.width-40,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                      color: Colors.grey.withOpacity(0.2)
                  )
                ]
            ),
            child: const Center(
              child: Text('SEND',
                style: TextStyle(
                  color: Colors.black87,
                  letterSpacing: 3.0,
                ),),
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        const Text('Verification Code',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 30.0
          ),),

        const Spacer(),
        Container(
          padding: const EdgeInsets.only(left: 15.0,top: 5.0),
          height: 60.0,
          width: MediaQuery.of(context).size.width-40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                spreadRadius: 3.0,
                color: Colors.grey.withOpacity(0.2)
              )
            ]
          ),
          child:  TextField(
            controller: otpController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Enter 6 digits code",
            ),
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () async {
            PhoneAuthCredential phoneAuthCredential =
            PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
            setState(() {
              phoneController.clear();
            });
          },
          child: Container(
            height: 60.0,
            width: MediaQuery.of(context).size.width-40,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  spreadRadius: 3.0,
                  color: Colors.grey.withOpacity(0.2)
                )
              ]
            ),
            child: const Center(
              child: Text('Verify',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
              ),),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          title: const Text('Phone-Verification',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20.0,
            letterSpacing: 5.0
          ),),
        ),
        body: Container(
          child: showLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
