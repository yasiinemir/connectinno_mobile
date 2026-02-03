import 'package:connectionno_mobile/core/errors/auth_error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final isLoggedIn = authRepository.isLoggedIn;
      if (isLoggedIn) {
        emit(const Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(event.email, event.password);
        emit(const Authenticated());
      } catch (e) {
        emit(AuthError(AuthErrorHandler.from(e)));
        emit(Unauthenticated());
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(event.email, event.password);
        emit(const Authenticated());
      } catch (e) {
        emit(AuthError(AuthErrorHandler.from(e)));
        emit(Unauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
