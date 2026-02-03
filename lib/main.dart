import 'package:connectionno_mobile/data/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/injection_container.dart' as di; // Dependency Injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Firebase Başlat (Henüz eklemediysen yorum satırına al)
  // await Firebase.initializeApp();

  // 2. Hive Başlat
  await Hive.initFlutter();

  // NoteModelAdapter'ın oluşturulduğundan emin ol (daha önce konuşmuştuk)
  // Eğer hata verirse: flutter pub run build_runner build
  Hive.registerAdapter(NoteModelAdapter());

  // 3. Dependency Injection Başlat (Yazdığımız init fonksiyonu)
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectinno Case',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // Şimdilik boş bir Container gösterelim, hata almayalım.
      home: const Scaffold(body: Center(child: Text("Altyapı Hazırlanıyor..."))),
    );
  }
}
