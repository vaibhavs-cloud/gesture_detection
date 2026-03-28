import 'package:hand_landmarker/hand_landmarker.dart';

class GestureService {
  /// Detects a gesture from a list of Hand landmarks.
  /// Uses finger-up/down heuristics based on the 21-landmark model.
  String detectGesture(List<Hand> hands) {
    if (hands.isEmpty) return "No hand detected";

    final landmarks = hands.first.landmarks;

    // 21 landmarks per hand. Key indices:
    // Thumb tip=4, thumb IP=3
    // Index tip=8, index PIP=6
    // Middle tip=12, middle PIP=10
    // Ring tip=16, ring PIP=14
    // Pinky tip=20, pinky PIP=18

    // A finger is "up" if its tip is ABOVE (lower y) its PIP joint.
    // Normalized coords: y=0 is top, y=1 is bottom.
    bool thumb = landmarks[4].y < landmarks[3].y;
    bool index = landmarks[8].y < landmarks[6].y;
    bool middle = landmarks[12].y < landmarks[10].y;
    bool ring = landmarks[16].y < landmarks[14].y;
    bool pinky = landmarks[20].y < landmarks[18].y;

    int count = 0;
    if (index) count++;
    if (middle) count++;
    if (ring) count++;
    if (pinky) count++;

    if (count == 4 && thumb) return "Hello / 5";
    if (count == 0 && !thumb) return "Yes (Fist)";
    if (count == 1 && index) return "1";
    if (count == 2 && index && middle) return "Peace / 2";
    if (count == 3 && index && middle && ring) return "3";
    if (count == 4 && !thumb) return "4";
    if (thumb && count == 0) return "Thumbs Up";

    return "Detecting...";
  }
}
