import 'package:flutter/material.dart';
import '../../common/color.dart';
import '../../services/firestore_service.dart';
import '../login_screen.dart';
import 'chat_screen.dart';

class ListChatScreen extends StatefulWidget {
  static const String id = 'list_chat_screen';

  @override
  _ListChatScreenState createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _users = [];
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await _firestoreService.getUsers();
    final currenUser = await _firestoreService.getCurrentUser();
    setState(() {
      _users = users;
      _currentUserEmail = currenUser?.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh Sách Chat',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.matchaLight,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors().default1,
              AppColors().default2,
            ],
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(10),
          itemCount: _users.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[300],
            thickness: 1.0,
          ),
          itemBuilder: (context, index) {
            final user = _users[index];
            return ListTile(
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/default_avatar.jpg'),
                  ),
                ),
              ),
              title: Text(
                user['email'] ?? 'Email không xác định',
                style: TextStyle(color: AppColors.textColor),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatScreen.id,
                  arguments: {
                    'currentUserEmail': _currentUserEmail,
                    'otherUserEmail': user['email']
                  },
                );
              },
              trailing: Icon(
                Icons.navigate_next,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.all(15),
            );
          },
        ),
      ),
    );
  }
}
