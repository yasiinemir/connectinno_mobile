import 'package:connectionno_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:connectionno_mobile/data/datasources/note_local_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthRemoteDataSource remoteDataSource;
  final NoteLocalDataSource noteLocalDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required this.noteLocalDataSource});

  @override
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  @override
  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();

    await noteLocalDataSource.clearAll();
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await remoteDataSource.getCurrentUser();
    return user != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<String?> getToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }
}
