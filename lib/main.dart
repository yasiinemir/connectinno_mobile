import 'package:connectionno_mobile/logic/auth_bloc/auth_state.dart';
import 'package:connectionno_mobile/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/injection_container.dart' as di;
import 'data/models/note_model.dart';
import 'logic/auth_bloc/auth_bloc.dart';
import 'logic/auth_bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()))],
      child: MaterialApp(
        title: 'Connectinno Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Notlar"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    ),
                  ],
                ),
                body: const Center(child: Text("Giriş Başarılı! Notlar Yüklenecek...")),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
