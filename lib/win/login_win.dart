import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:swift_chat/win/chat_win.dart';

import '../components/rounded_button.dart';
import '../utils/constants.dart';

class LoginWindow extends StatefulWidget {
  static String id = 'login_win';
  @override
  _LoginWindowState createState() => _LoginWindowState();
}

class _LoginWindowState extends State<LoginWindow> {
  // This is the Authentication Private Object
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        color: Colors.black,
        dismissible: true,
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RoundedButton(
                    title: 'Log In',
                    color: Colors.lightBlueAccent,
                    onPress: () async {
                      setState(() {
                        showSpinner = true;
                      });

                      // Here we sign in user with _auth object.
                      // This function returns Future as it can take any amount of time.
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          email = '';
                          password = '';
                          Navigator.pushNamed(context, ChatWindow.id);
                        }
                      } catch (error) {
                        print(error);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
