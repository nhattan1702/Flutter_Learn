import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<User?> register(String email, String password) async {
    return await authService.register(email, password);
  }

  Future<User?> signIn(String email, String password) async {
    return await authService.signIn(email, password);
  }
}
