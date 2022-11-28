import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/screens/welcome_win.dart';

import '../components/message_stream.dart';
import '../main.dart';
import '../utils/constants.dart';

class ChatWindow extends StatefulWidget {
  static String id = 'chat_win';
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late final User loggedInUser;
  late String messageText = '';
  Color sendButtonColor = Colors.white38;
  late bool isTyping = false;
  final messageTextController = TextEditingController();

  // The Stream - snapshots()
  // The Channel we subscribe to - _firestore.collection('messages')
  // The Data - snapshot.docs.data()
  // void messagesStreamSubscribe() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      // This function returns Future as it can take any amount of time.
      loggedInUser = _auth.currentUser!;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF9F73AA),
        title: const Text(
          'Chat️',
          style: TextStyle(color: Colors.white70),
        ),
        leading: Material(
          color: const Color(0XFF9F73AA),
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.popAndPushNamed(context, WelcomeWindow.id);
            },
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.account_circle,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0XFF9F73AB), Color(0XFFA3C7D6)]),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MessageStream(currentUser: loggedInUser),
              Container(
                padding: const EdgeInsets.all(6),
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Material(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Colors.blueGrey[100],
                          elevation: 4.0,
                          child: TextField(
                            controller: messageTextController,
                            onChanged: (value) {
                              if (value != '') {
                                messageText = value;
                                setState(() {
                                  isTyping = true;
                                });
                              } else {
                                messageText = value;
                                setState(() {
                                  isTyping = false;
                                });
                              }
                            },
                            onEditingComplete: () {
                              print('aaa');
                            },
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Visibility(
                        visible: isTyping,
                        child: Expanded(
                          child: GestureDetector(
                            onTap: () {
                              messageTextController.clear();
                              setState(() {
                                isTyping = false;
                              });
                              if (messageText != '') {
                                startVibration(VibrationTypes.lightImpact);
                                _firestore.collection('messages').add(
                                  {
                                    'text': messageText,
                                    'sender': loggedInUser.email,
                                    'date and time': DateTime.now().toString(),
                                  },
                                );
                              }
                              messageText = '';
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.blueAccent),
                              child: Icon(
                                CupertinoIcons.arrow_turn_up_right,
                                color: sendButtonColor,
                              ),
                              // child: Text(
                              //   'Send',
                              //   style: TextStyle(
                              //     color: sendButtonColor,
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18.0,
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
