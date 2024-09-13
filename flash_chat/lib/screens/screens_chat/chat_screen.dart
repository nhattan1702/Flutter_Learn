import 'package:flash_chat/common/color.dart';
import 'package:flash_chat/repositories/firestore_repository.dart';
import 'package:flash_chat/screens/screens_chat/listchat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/common/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/services/firestore_service.dart';
import 'messages_stream.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirestoreRepository _firestoreRepository = FirestoreRepository();
  final messageTextController = TextEditingController();
  late String messageText;
  User? loggedInUser;
  final ScrollController _scrollController = ScrollController();
  late String otherUserEmail;
  late String currentUserEmail;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _firestoreRepository.getCurrentUser();
    if (user != null) {
      setState(() {
        loggedInUser = user;
        currentUserEmail = user.email ?? '';

        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          otherUserEmail = args['otherUserEmail'] ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      currentUserEmail = args['currentUserEmail'] ?? '';
      otherUserEmail = args['otherUserEmail'] ?? '';
    }
    return Scaffold(
      backgroundColor: AppColors().default1,
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textColor),
            onPressed: () {
              Navigator.pushReplacementNamed(context, ListChatScreen.id);
            },
          ),
          actions: <Widget>[],
          title: Text(
            '⚡️Chat',
            style: TextStyle(color: AppColors.textColor),
          ),
          backgroundColor: AppColors().default1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (loggedInUser != null)
              Expanded(
                child: MessagesStream(
                  firestoreService: _firestoreService,
                  loggedInUser: loggedInUser!,
                  scrollController: _scrollController,
                  otherUserEmail: otherUserEmail,
                ),
              ),
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
                      if (loggedInUser != null) {
                        _firestoreRepository.sendMessage(
                            messageText, currentUserEmail, otherUserEmail);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      }
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
