import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignAI',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF00796B), // Pastel teal for buttons
        scaffoldBackgroundColor: const Color(0xFFE0F7FA), // soft cyan bg
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          bodyLarge: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00796B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}