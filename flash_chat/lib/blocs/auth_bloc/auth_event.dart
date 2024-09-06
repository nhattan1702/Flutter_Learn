abstract class AuthEvent {}

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterUserEvent({required this.email, required this.password});
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}
