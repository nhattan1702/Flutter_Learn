import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class FirestoreRepository {
  final FirestoreService _firestoreService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirestoreRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
  }

  Future<void> sendMessage(
      String messageText, String senderEmail, String receiverEmail) async {
    String chatId = _getChatId(senderEmail, receiverEmail);
    await _firestoreService.sendMessage(
        chatId, messageText, senderEmail, receiverEmail);
  }

  Stream<QuerySnapshot> getMessagesStream(
      String currentUserEmail, String otherUserEmail) {
    String chatId = _getChatId(currentUserEmail, otherUserEmail);
    return _firestoreService.getMessagesStream(chatId);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return [];
      }

      final currentUserEmail = currentUser.email;

      final snapshot = await _firestoreService.getUsers();
      return snapshot.docs
          .where((doc) => doc['email'] != currentUserEmail)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error getting users: $e");
      return [];
    }
  }

  String _getChatId(String user1, String user2) {
    List<String> users = [user1, user2]..sort();
    return users.join('_');
  }

  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    await _firestoreService.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
    );
  }

  Future<bool> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    return await _firestoreService.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
