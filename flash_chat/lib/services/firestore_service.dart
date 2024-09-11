import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getMessagesStream(
      String currentUserEmail, String otherUserEmail) {
    String chatId = getChatId(currentUserEmail, otherUserEmail);
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('time')
        .snapshots();
  }

  String getChatId(String user1, String user2) {
    List<String> users = [user1, user2]..sort();
    return users.join('_');
  }

  Future<void> sendMessage(
      String messageText, String senderEmail, String receiverEmail) async {
    String chatId = getChatId(senderEmail, receiverEmail);
    await _firestore.collection('messages').add({
      'message': messageText,
      'sender': senderEmail,
      'receiver': receiverEmail,
      'time': FieldValue.serverTimestamp(),
      'chatId': chatId,
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return [];
      }

      final currentUserEmail = currentUser.email;

      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .where((doc) => doc['email'] != currentUserEmail)
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
