import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeechIntegrationScreen extends StatelessWidget {
  const SpeechIntegrationScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FA),
      appBar: AppBar(
        title: const Text("Speech Integration", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFB8C00),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Speech to Gesture Lessons",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFB8C00)),
          ),
          const SizedBox(height: 15),
          _videoCard(
            "Speech Recognition Basics",
            "Learn how the AI interprets your voice into signs.",
            "https://www.youtube.com/watch?v=tkMg8g8vVUo", // Generic ASL for demo
            "https://img.youtube.com/vi/tkMg8g8vVUo/0.jpg",
          ),
          _videoCard(
            "Voice Command Training",
            "Efficiently using voice to trigger gestures.",
            "https://www.youtube.com/watch?v=v1desDduz5M",
            "https://img.youtube.com/vi/v1desDduz5M/0.jpg",
          ),
          const SizedBox(height: 30),
          const Text(
            "Effective Speech Tips",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _tipTile("Speak clearly and at a moderate pace."),
          _tipTile("Minimize background noise for better accuracy."),
          _tipTile("Use short, direct phrases for faster translation."),
        ],
      ),
    );
  }

  Widget _videoCard(String title, String subtitle, String url, String thumbUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(thumbUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                const Icon(Icons.play_circle_fill, size: 60, color: Colors.white70),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipTile(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFFB8C00), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
