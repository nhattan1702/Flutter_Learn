import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
late User loggedInUser;
final ScrollController _scrollController = ScrollController();
class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  
  late String messageText;
 

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser () async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      
    }
  }

  void messagesStream() async {
   await for (var snapshot in firestore.collection('messages').snapshots()){
    for (var message in snapshot.docs) {
      print(message.data());
    }
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
               // messagesStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp(), 
                      });

                    WidgetsBinding.instance.addPostFrameCallback((_){
                    _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                      );
                    });
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
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
         stream: firestore.collection('messages')
        .orderBy('timestamp', descending: true) 
        .snapshots(),
        
        builder: (context, snapshot) {
            if (snapshot.hasData) {
            final messages = snapshot.data!.docs.reversed;  
            List<MessgaeBubble> messageBubbles = [];

            for (var message in messages) {
              final messageData = message.data() as Map<String, dynamic>;
              final messageText = messageData['text'];
              final messageSender = messageData['sender'];

              final currenUser = loggedInUser.email;

              final messageBubble = MessgaeBubble(sender: messageSender, text: messageText, isMe: currenUser == messageSender,);
              messageBubbles.add(messageBubble);
            }

            return Expanded(
              child: ListView(
                controller: _scrollController,
                reverse: false,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                children: messageBubbles,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        );
  }
}


class MessgaeBubble extends StatelessWidget {

  MessgaeBubble({required this.sender, required this.text, required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget> [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              sender,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15
              ),
              ),
          ),
          Material(
            borderRadius: isMe 
              ? 
              BorderRadius.only(
                    topLeft: Radius.circular(30), 
                    bottomLeft: Radius.circular(30), 
                    bottomRight: Radius.circular(30)) 
              : 
              BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                      text,
                      style:  TextStyle(
                        fontSize: 20,
                        color: isMe ? Colors.white : Colors.black54
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}