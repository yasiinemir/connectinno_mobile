import 'package:connectionno_mobile/core/constants/app_theme.dart';
import 'package:connectionno_mobile/core/network/api_manager.dart';
import 'package:connectionno_mobile/logic/theme_cubit/theme_cubit.dart';
import 'package:connectionno_mobile/presentation/screens/home_screen.dart';
import 'package:connectionno_mobile/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/models/note_model.dart';
import 'data/models/sync_task_model.dart';
import 'core/network/network_info.dart';
import 'data/datasources/note_local_data_source.dart';
import 'data/datasources/note_remote_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/note_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'logic/note_bloc/note_bloc.dart';
import 'logic/auth_bloc/auth_bloc.dart';
import 'logic/note_bloc/note_event.dart';
import 'logic/auth_bloc/auth_event.dart';
import 'logic/auth_bloc/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(SyncTaskModelAdapter());
  Hive.registerAdapter(SyncActionAdapter());

  final noteBox = await Hive.openBox<NoteModel>('notes');
  final queueBox = await Hive.openBox<SyncTaskModel>('sync_queue');

  final connectivity = Connectivity();
  final networkInfo = NetworkInfoImpl(connectivity);
  final apiManager = ApiManager();
  final firebaseAuth = FirebaseAuth.instance;

  final noteLocalDataSource = NoteLocalDataSourceImpl(noteBox: noteBox, queueBox: queueBox);

  final noteRemoteDataSource = NoteRemoteDataSourceImpl(
    apiManager: apiManager,
    firebaseAuth: firebaseAuth,
  );

  final authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth: firebaseAuth);

  final noteRepository = NoteRepositoryImpl(
    remoteDataSource: noteRemoteDataSource,
    localDataSource: noteLocalDataSource,
    networkInfo: networkInfo,
  );

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    noteLocalDataSource: noteLocalDataSource,
  );

  runApp(MyApp(authRepository: authRepository, noteRepository: noteRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final NoteRepositoryImpl noteRepository;

  const MyApp({super.key, required this.authRepository, required this.noteRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository)..add(AuthCheckRequested()),
        ),
        BlocProvider<NoteBloc>(
          create: (context) => NoteBloc(noteRepository: noteRepository)..add(LoadNotes()),
        ),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Offline First Notes',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme, // Aydınlık
            darkTheme: AppTheme.darkTheme, // Karanlık
            themeMode: themeMode,

            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const HomeScreen();
                } else if (state is Unauthenticated) {
                  return const LoginScreen();
                }

                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              },
            ),
          );
        },
      ),
    );
  }
}
