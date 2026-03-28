import 'package:flutter/material.dart';
import 'gesture_mastery_screen.dart';
import 'speech_integration_screen.dart';
import 'grammar_context_screen.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Learning Hub",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00796B), Color(0xFF4DB6AC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Progress",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Overall Mastery", style: TextStyle(color: Colors.black54)),
                            Text("65%", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: 0.65,
                            backgroundColor: Color(0xFFE0F2F1),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00796B)),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Learning Modules",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildModuleCard(
                    context,
                    "Gesture Mastery",
                    "Learn common ASL signs and hand movements.",
                    Icons.back_hand_rounded,
                    const Color(0xFFE0F2F1),
                    const Color(0xFF00796B),
                    "24 Lessons",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GestureMasteryScreen()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    context,
                    "Speech Integration",
                    "How to use voice commands effectively.",
                    Icons.mic_rounded,
                    const Color(0xFFFFF3E0),
                    const Color(0xFFFB8C00),
                    "12 Lessons",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SpeechIntegrationScreen()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    context,
                    "Grammar & Context",
                    "Master the nuances of sign language structure.",
                    Icons.menu_book_rounded,
                    const Color(0xFFF3E5F5),
                    const Color(0xFF8E24AA),
                    "18 Lessons",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GrammarContextScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Daily Challenge",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004D40), Color(0xFF00796B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 40),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Sign of the Day",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "Practice the sign for 'Gratitude'",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00796B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Start"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, IconData icon, Color bgColor, Color iconColor, String lessonCount, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.play_circle_fill_rounded, size: 16, color: iconColor),
                const SizedBox(width: 5),
                Text(lessonCount, style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black26),
        onTap: onTap,
      ),
    );
  }
}
