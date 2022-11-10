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
  Color sendButtonColor = Colors.grey;
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
        title: const Text('Chat ⚡️'),
        leading: Material(
          color: Colors.blue,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.popAndPushNamed(context, WelcomeWindow.id);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(currentUser: loggedInUser),
            Container(
              padding: EdgeInsets.all(6),
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
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
                                sendButtonColor = Colors.blueAccent;
                              });
                            } else {
                              messageText = value;
                              setState(() {
                                sendButtonColor = Colors.grey;
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
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        if (messageText != '') {
                          startVibration(VibrationTypes.lightImpact);
                          _firestore.collection('messages').add(
                            {
                              'text': messageText,
                              'sender': loggedInUser.email,
                              'date and time': DateTime.now().toString(),
                            },
                          );
                          setState(() {
                            sendButtonColor = Colors.grey;
                          });
                        } else {}
                        messageText = '';
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: sendButtonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
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
    );
  }
}
