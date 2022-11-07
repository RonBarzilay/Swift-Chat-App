import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/components/message_stream.dart';
import 'package:swift_chat/win/welcome_win.dart';

import '../utils/constants.dart';

class ChatWindow extends StatefulWidget {
  static String id = 'chat_win';
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  late String messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      // This function returns Future as it can take any amount of time.
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    } catch (error) {
      print(error);
    }
  }

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
                  CupertinoSliverNavigationBar(
                    largeTitle: const Text('Chat ⚡️'),
                    trailing: Material(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _auth.signOut();
                          Navigator.popAndPushNamed(context, WelcomeWindow.id);
                        },
                      ),
                    ),
                  ),
                ];
              },
              body: CupertinoPageScaffold(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MessageStream(currentUserEmail: loggedInUser?.email),
                      Container(
                        decoration: kMessageContainerDecoration,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(32.0),
                                color: Colors.blueGrey[100],
                                elevation: 4.0,
                                child: TextField(
                                  controller: messageTextController,
                                  onChanged: (value) {
                                    messageText = value;
                                  },
                                  decoration: kMessageTextFieldDecoration,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                messageTextController.clear();
                                _firestore.collection('messages').add(
                                  {
                                    'text': messageText,
                                    'sender': loggedInUser?.email
                                  },
                                );
                              },
                              child: Text(
                                'Send',
                                style: kSendButtonTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
