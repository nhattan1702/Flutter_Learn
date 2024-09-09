import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  Future<UserModel?> getUserFromFirestore(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }
}

class SignUpWithEmailAndPasswordFailure implements Exception {
  final String message;

  const SignUpWithEmailAndPasswordFailure([
    this.message = 'Lỗi',
  ]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email không hợp lệ hoặc bị sai định dạng',
        );

      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'Người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ để được hỗ trợ',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'Một tài khoản đã tồn tại cho email đó',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Hoạt động không được phép. Vui lòng liên hệ với bộ phận hỗ trợ',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}

class SignInWithEmailAndPasswordFailure implements Exception {
  final String message;

  const SignInWithEmailAndPasswordFailure([this.message = 'Lỗi']);

  factory SignInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignInWithEmailAndPasswordFailure(
          'Email không hợp lệ hoặc bị sai định dạng',
        );
      case 'user-disabled':
        return const SignInWithEmailAndPasswordFailure(
          'Người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ để được hỗ trợ',
        );
      case 'invalid-credential':
        return const SignInWithEmailAndPasswordFailure(
          'Sai tài khoản hoặc mật khẩu, vui lòng kiểm tra lại',
        );
      default:
        return const SignInWithEmailAndPasswordFailure();
    }
  }
}
