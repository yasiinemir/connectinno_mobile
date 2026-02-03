import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // 1. Açılış Kontrolü
    on<AuthCheckRequested>((event, emit) async {
      try {
        final isSignedIn = await authRepository.isAuthenticated();
        if (isSignedIn) {
          final user = await authRepository.getCurrentUser();
          emit(Authenticated(user!));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // 2. Giriş Yap
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(event.email, event.password);
        final user = await authRepository.getCurrentUser();
        emit(Authenticated(user!));
      } catch (e) {
        emit(AuthError("Giriş başarısız: $e"));
      }
    });

    // 3. Kayıt Ol
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(event.email, event.password);
        final user = await authRepository.getCurrentUser();
        emit(Authenticated(user!));
      } catch (e) {
        emit(AuthError("Kayıt başarısız: $e"));
      }
    });

    // 4. Çıkış Yap
    on<LogoutRequested>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
