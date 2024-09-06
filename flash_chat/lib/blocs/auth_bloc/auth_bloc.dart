import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.register(event.email, event.password);
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(AuthError("Đăng ký không thành công "));
        }
      } catch (e) {
        if (e is SignUpWithEmailAndPasswordFailure) {
          emit(AuthError(e.message));
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });

    on<LoginUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signIn(event.email, event.password);
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(AuthError("Đăng nhập không thành không"));
        }
      } catch (e) {
        if (e is SignInWithEmailAndPasswordFailure) {
          emit(AuthError(e.message));
        } else {
          emit(AuthError("Lỗi"));
        }
      }
    });
  }
}
