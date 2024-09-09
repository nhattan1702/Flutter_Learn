import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUp(event.email, event.password);

        if (user == null) {
          emit(AuthError("Đăng ký không thành công"));
        } else {
          emit(Authenticated(user: user));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signIn(event.email, event.password);

        if (user == null) {
          emit(AuthError("Đăng nhập không thành công"));
        } else {
          emit(Authenticated(user: user));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
