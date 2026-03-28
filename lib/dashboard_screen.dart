import 'package:flutter/material.dart';
import 'gesture_screen.dart';
import 'speech_gesture_screen.dart';
import 'learning_screen.dart';
import 'practice_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _card(context, "Gesture → Speech", Icons.pan_tool_rounded, const GestureScreen(), Color(0xFFF3E5F5), Color(0xFFE1BEE7)),
            _card(context, "Speech → Gesture", Icons.mic_rounded, const SpeechGestureScreen(), Color(0xFFE8F5E9), Color(0xFFC8E6C9)),
            _card(context, "Learning Mode", Icons.school_rounded, const LearningScreen(), Color(0xFFFFFDE7), Color(0xFFFFF9C4)),
            _card(context, "Practice Mode", Icons.fitness_center_rounded, const PracticeScreen(), Color(0xFFFCE4EC), Color(0xFFF8BBD0)),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, String title, IconData icon, Widget page, Color color1, Color color2) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}