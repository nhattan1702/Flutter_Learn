import 'dart:io';

abstract class AuthEvent {}

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;
  // final File image;

  RegisterUserEvent({
    required this.email,
    required this.password,
    // required this.image
  });
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}
