import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  final String? currentUserEmail;
  MessageStream({Key? key, this.currentUserEmail}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          print(messageSender + messageText + currentUserEmail);
          final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: messageSender == currentUserEmail);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: ListView(
              reverse: true,
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}
