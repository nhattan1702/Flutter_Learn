import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/firestore_service.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService firestoreService;

  UserRepository({required this.firestoreService});

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getFilteredUsers() async {
    final currentUser = await firestoreService.getCurrentUser();
    final users = await getUsers();
    return users.where((user) => user['email'] != currentUser?.email).toList();
  }
}
