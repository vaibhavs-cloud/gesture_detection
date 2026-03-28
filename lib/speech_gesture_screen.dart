import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class SpeechGestureScreen extends StatelessWidget {
  const SpeechGestureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // pastel mint
      appBar: AppBar(
        title: const Text("Speech → Gesture",
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Speech to Gesture AI Mode",
            style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}