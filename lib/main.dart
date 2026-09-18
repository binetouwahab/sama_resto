import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SamaRestoApp());
}

class SamaRestoApp extends StatelessWidget {
  const SamaRestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SamaResto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFC0202D),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC0202D)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('SamaResto — Firebase connecté ✅')),
      ),
    );
  }
}