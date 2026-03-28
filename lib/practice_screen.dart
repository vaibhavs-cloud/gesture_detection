import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // pastel pink
      appBar: AppBar(
        title: const Text("Practice Mode",
            style:
            TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _card("Practice Gestures", Color(0xFFF3E5F5), Color(0xFFE1BEE7)),
          _card("Practice Speech Commands", Color(0xFFE8F5E9), Color(0xFFC8E6C9)),
          _card("Interactive AI Challenges", Color(0xFFFFFDE7), Color(0xFFFFF9C4)),
        ],
      ),
    );
  }

  Widget _card(String title, Color color1, Color color2) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient:
        LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }
}