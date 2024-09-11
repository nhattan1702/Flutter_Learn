import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<UserModel?> signUp(String email, String password) async {
    User? user =
        await authService.createUserWithEmailAndPassword(email, password);
    if (user != null) {
      UserModel userModel = UserModel(
        id: user.uid,
        email: email,
        password: password,
        //     image: image,
      );
      await authService.saveUserToFirestore(userModel);
      return userModel;
    }
    return null;
  }

  Future<UserModel?> signIn(String email, String password) async {
    User? user = await authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      return await authService.getUserFromFirestore(user.uid);
    }
    return null;
  }
}
