import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'role_selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Firestore offline persistence for faster loading
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    print("✅ Firebase Successfully Connected!");
    runApp(const ExamSeatingApp());
  } catch (e) {
    print("❌ Firebase Connection Failed: $e");
    runApp(const ErrorApp());
  }
}

class ExamSeatingApp extends StatelessWidget {
  const ExamSeatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Seating Arrangement',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFECDCAB),
        scaffoldBackgroundColor: const Color(0xFFFCFCF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFECDCAB),
          primary: const Color(0xFFECDCAB),
          surface: const Color(0xFFFCFCF7), // ✅ FIXED: Changed from 'background' to 'surface'
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Antonio', fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontFamily: 'Antonio', fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontFamily: 'Antonio', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'Antonio', fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontFamily: 'Antonio', fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontFamily: 'Antonio'),
          bodyMedium: TextStyle(fontFamily: 'Antonio'),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFECDCAB),
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Antonio', // ✅ FIXED: Removed extra quote
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFECDCAB),
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'Antonio',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFECDCAB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFECDCAB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFECDCAB), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        cardTheme: CardThemeData( // ✅ FIXED: Changed from CardTheme to CardThemeData
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const RoleSelectionPage(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[700]),
              const SizedBox(height: 16),
              Text(
                '❌ Firebase Connection Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your Firebase configuration',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
