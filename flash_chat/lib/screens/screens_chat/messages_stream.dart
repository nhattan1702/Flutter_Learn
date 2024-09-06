import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'package:flash_chat/services/firestore_service.dart';

class MessagesStream extends StatefulWidget {
  final FirestoreService firestoreService;
  final User loggedInUser;
  final ScrollController scrollController;

  MessagesStream({
    required this.firestoreService,
    required this.loggedInUser,
    required this.scrollController,
  });

  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.firestoreService.getMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!.docs.reversed;
            List<MessageBubble> messageBubbles = [];

            for (var message in messages) {
              final messageData = message.data() as Map<String, dynamic>;
              final messageText = messageData['text'];
              final messageSender = messageData['sender'];

              final currenUser = widget.loggedInUser.email;

              final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: currenUser == messageSender,
              );
              messageBubbles.add(messageBubble);
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.scrollController.jumpTo(
                widget.scrollController.position.maxScrollExtent,
              );
            });

            return ListView(
              controller: widget.scrollController,
              reverse: false,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              children: messageBubbles,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
