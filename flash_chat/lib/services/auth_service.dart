import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
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

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException Code: ${e.code}");
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      throw const SignInWithEmailAndPasswordFailure();
    }
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
