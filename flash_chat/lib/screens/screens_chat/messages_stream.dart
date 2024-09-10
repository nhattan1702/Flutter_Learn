import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'package:flash_chat/services/firestore_service.dart';

class MessagesStream extends StatefulWidget {
  final FirestoreService firestoreService;
  final User loggedInUser;
  final String otherUserEmail;
  final ScrollController scrollController;

  MessagesStream({
    required this.firestoreService,
    required this.loggedInUser,
    required this.scrollController, 
    required this.otherUserEmail,
  });

  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.firestoreService.getMessagesStream(widget.loggedInUser.email!, widget.otherUserEmail),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];

          for (var message in messages) {
            final messageData = message.data() as Map<String, dynamic>;
            final messageText = messageData['message'] as String?;
            final messageSender = messageData['sender'] as String?; 

            if (messageText != null && messageSender != null) {
              final messageBubble = MessageBubble(
                sender: messageSender,
                message: messageText,
                isMe: widget.loggedInUser.email == messageSender,
              );
              messageBubbles.add(messageBubble);
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (widget.scrollController.hasClients) {
              widget.scrollController.animateTo(
                widget.scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
