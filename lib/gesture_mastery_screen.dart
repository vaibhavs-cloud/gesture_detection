import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GestureMasteryScreen extends StatelessWidget {
  const GestureMasteryScreen({super.key});

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
        title: const Text("Gesture Mastery", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Curated Playlists",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
          ),
          const SizedBox(height: 15),
          _videoCard(
            "ASL for Beginners",
            "A comprehensive playlist to start your ASL journey.",
            "https://youtube.com/playlist?list=PLxYMaKXKMMcMgg4f47WkG7AM0bb3AyjTi&si=bSC3VXIeJAQXEyyp",
            "https://img.youtube.com/vi/LpLM-8Uj1Bc/0.jpg",
            isPlaylist: true,
          ),
          _videoCard(
            "Daily ASL Practice",
            "Consistent practice for common signs.",
            "https://youtube.com/playlist?list=PLFjydPMg4DapfRTBMokl09Ht-fhMOAYf6&si=IhqkzpIZ66eMhftX",
            "https://img.youtube.com/vi/v1desDduz5M/0.jpg",
            isPlaylist: true,
          ),
          _videoCard(
            "ASL Lessons Playlist 1",
            "Comprehensive collection of American Sign Language lessons.",
            "https://youtube.com/playlist?list=PLMN7QCuj6dfaUwmtdkdKhINGZzyGwp7Q1&si=HjLbXAkAXRqk-alv",
            "https://img.youtube.com/vi/Vj_13bdU4dU/0.jpg",
            isPlaylist: true,
          ),
          _videoCard(
            "ASL Lessons Playlist 2",
            "Advanced and varied sign language tutorials.",
            "https://youtube.com/playlist?list=PLMN7QCuj6dfY6wtU3KhX0hqs_YZdIWvQU&si=lzrnVBkLhZ8AB6pz",
            "https://img.youtube.com/vi/odDE9nzsCw4/0.jpg",
            isPlaylist: true,
          ),
          const SizedBox(height: 30),
          const Text(
            "Individual Lessons",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
          ),
          const SizedBox(height: 15),
          _videoCard(
            "Daily Activities Signs",
            "Common signs for everyday actions.",
            "https://youtu.be/c_s0OItpTmA?si=NUiQnIa9i0SxPlGQ",
            "https://img.youtube.com/vi/c_s0OItpTmA/0.jpg",
          ),
          _videoCard(
            "ASL Signs for Beginners",
            "Quickly learn basic signs with this guide.",
            "https://youtu.be/i520LPUkpYc?si=-hGzujXTIDjZGGmZ",
            "https://img.youtube.com/vi/i520LPUkpYc/0.jpg",
          ),
          _videoCard(
            "Mastering ASL Gestures",
            "In-depth look at mastering your hand movements.",
            "https://youtu.be/NXNq_ER2jT4?si=kMrzb-SSNK-uPTd7",
            "https://img.youtube.com/vi/NXNq_ER2jT4/0.jpg",
          ),
          _videoCard(
            "ASL Alphabet & Letters",
            "Master the ASL alphabet in detail.",
            "https://youtu.be/LpLM-8Uj1Bc?si=-LusZokE9W5vgl0a",
            "https://img.youtube.com/vi/LpLM-8Uj1Bc/0.jpg",
          ),
          _videoCard(
            "Common ASL Greetings",
            "Essential greetings for daily conversation.",
            "https://youtu.be/v1desDduz5M?si=SdDLGcCON2TXdNX8",
            "https://img.youtube.com/vi/v1desDduz5M/0.jpg",
          ),
          _videoCard(
            "Numbers 1-10 in ASL",
            "Learn basic numbers quickly.",
            "https://youtu.be/lC_DCrDJSeQ?si=__xB19sCx-gkxa9N",
            "https://img.youtube.com/vi/lC_DCrDJSeQ/0.jpg",
          ),
          _videoCard(
            "Family Members",
            "Signs for mom, dad, and more.",
            "https://youtu.be/RhQvlq-mZtA?si=ilbX_9zGX9dCMXTI",
            "https://img.youtube.com/vi/RhQvlq-mZtA/0.jpg",
          ),
          _videoCard(
            "ASL Basics Part 1",
            "Starting your journey with basic signs.",
            "https://youtu.be/Vj_13bdU4dU?si=T-gIZTg9zqqdxTVW",
            "https://img.youtube.com/vi/Vj_13bdU4dU/0.jpg",
          ),
          _videoCard(
            "Learn ASL in 30 Minutes",
            "A comprehensive overview of sign language.",
            "https://youtu.be/0FcwzMq4iWg?si=rtKdvLenfYmVmrVP",
            "https://img.youtube.com/vi/0FcwzMq4iWg/0.jpg",
          ),
          _videoCard(
            "Common ASL Phrases",
            "Useful phrases for everyday communication.",
            "https://youtu.be/NdK97BAt3V0?si=dVsaCjbb0YH5QKp-",
            "https://img.youtube.com/vi/NdK97BAt3V0/0.jpg",
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _videoCard(String title, String subtitle, String url, String thumbUrl, {bool isPlaylist = false}) {
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
                Icon(
                  isPlaylist ? Icons.playlist_play : Icons.play_circle_fill,
                  size: 60,
                  color: Colors.white70,
                ),
                if (isPlaylist)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black54,
                      child: const Text("PLAYLIST", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )
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
}
