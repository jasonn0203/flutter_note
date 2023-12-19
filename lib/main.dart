import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  // Khởi tạo Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //ROOT
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JS Note',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff000000),
          primaryColor: Color(0xffcdeff1)),
      home: const HomePage(),
    );
  }
}
