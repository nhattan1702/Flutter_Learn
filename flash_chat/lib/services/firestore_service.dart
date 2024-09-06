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

  Stream<QuerySnapshot> getMessagesStream() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String messageText, String senderEmail) async {
    await _firestore.collection('messages').add({
      'text': messageText,
      'sender': senderEmail,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
