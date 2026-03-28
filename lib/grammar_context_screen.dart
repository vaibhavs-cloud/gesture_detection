import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GrammarContextScreen extends StatelessWidget {
  const GrammarContextScreen({super.key});

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
        title: const Text("Grammar & Context", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8E24AA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Advanced ASL Structure",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8E24AA)),
          ),
          const SizedBox(height: 15),
          _videoCard(
            "ASL Sentence Structure",
            "Master Topic-Comment and SVO structures in ASL.",
            "https://youtu.be/IDghHm_w4k4?si=vFcodL-C5X8SJNUf",
            "https://img.youtube.com/vi/IDghHm_w4k4/0.jpg",
          ),
          _videoCard(
            "ASL Grammar Rules",
            "Learn the unique structure of Sign Language.",
            "https://youtu.be/c_s0OItpTmA?si=NUiQnIa9i0SxPlGQ",
            "https://img.youtube.com/vi/c_s0OItpTmA/0.jpg",
          ),
          _videoCard(
            "Non-Manual Markers",
            "Understanding facial expressions and body shifts.",
            "https://youtu.be/i520LPUkpYc?si=-hGzujXTIDjZGGmZ",
            "https://img.youtube.com/vi/i520LPUkpYc/0.jpg",
          ),
          _videoCard(
            "Contextual Signing",
            "How context changes the meaning of signs.",
            "https://youtu.be/NXNq_ER2jT4?si=kMrzb-SSNK-uPTd7",
            "https://img.youtube.com/vi/NXNq_ER2jT4/0.jpg",
          ),
          const SizedBox(height: 30),
          const Text(
            "Contextual Tips",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _tipTile("ASL uses Topic-Comment structure."),
          _tipTile("Tense is often established at the beginning."),
          _tipTile("Shoulder shifting can indicate different people."),
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
          const Icon(Icons.check_circle, color: Color(0xFF8E24AA), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
