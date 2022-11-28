import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/screens/chat_win.dart';

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

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.textStyle,
          child: CupertinoPageScaffold(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  const CupertinoSliverNavigationBar(
                    largeTitle: Text(
                      'Login',
                      style: TextStyle(color: Colors.white70),
                    ),
                    backgroundColor: Color(0XFF9F73AA),
                  )
                ];
              },
              body: CupertinoPageScaffold(
                resizeToAvoidBottomInset: false,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0XFF9F73AB), Color(0XFFA3C7D6)]),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontFamily: 'Agne',
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              pause: Duration(seconds: 1),
                              animatedTexts: [
                                TypewriterAnimatedText('Are you ready?',
                                    speed: Duration(milliseconds: 150)),
                                TypewriterAnimatedText('Sign in ...',
                                    speed: Duration(milliseconds: 150)),
                                TypewriterAnimatedText(
                                    'To Connect with others :)',
                                    speed: Duration(milliseconds: 150)),
                              ],
                              onTap: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 48.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Colors.blueGrey[100],
                          elevation: 8.0,
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your email'),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Colors.blueGrey[100],
                          elevation: 4.0,
                          child: TextField(
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
                                // Here we sign in user with _auth object.
                                // This function returns Future as it can take any amount of time.
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  if (user != null) {
                                    email = '';
                                    password = '';
                                    Navigator.pushNamed(context, ChatWindow.id);
                                  }
                                } catch (error) {
                                  print(error);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
