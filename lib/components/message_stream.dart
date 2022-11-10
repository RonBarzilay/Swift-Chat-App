import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  final User currentUser;
  MessageStream({Key? key, required this.currentUser}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlue,
            ),
          );
        }
        final messages = snapshots.data?.docs.reversed;

        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageSender = message.get('sender');
          final messageText = message.get('text');
          final messageDateTime = message.get('date and time');
          final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: messageSender == currentUser.email,
              dateTime: messageDateTime);
          messageBubbles.add(messageBubble);
          messageBubbles.sort((a, b) =>
              DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
