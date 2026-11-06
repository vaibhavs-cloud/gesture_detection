# SignAI: In-Depth Gesture-to-Voice Architecture & Logic

This document provides a comprehensive technical deep-dive into the tools, libraries, and custom logic used to achieve real-time gesture recognition and vocal translation in the SignAI Flutter application.

---

## 🛠️ Technology Stack & Libraries

The system relies on a tightly integrated stack of Flutter plugins to handle hardware access, machine learning inference, and audio synthesis:

1.  **Flutter Framework (Dart)**
    *   Acts as the core UI and state management engine. It handles the asynchronous streams between the camera, the ML model, and the audio engine.
2.  **`camera` (v0.11.4)**
    *   Provides low-level access to the device's hardware cameras.
    *   **Usage here:** Specifically configured to use the **front-facing lens** at a `medium` resolution preset to balance processing speed (FPS) and image clarity.
3.  **`hand_landmarker` (v2.2.0)**
    *   A Flutter wrapper around Google's **MediaPipe Hand Landmark API**.
    *   It utilizes an on-device Machine Learning model to detect the presence of hands and map 21 specific 3D coordinate points (landmarks) across the knuckles and fingertips.
    *   **Configuration:** Set to detect `numHands: 1` with a `minHandDetectionConfidence` of `0.6` using the `gpu` delegate for hardware acceleration.
4.  **`flutter_tts` (v3.8.3)**
    *   Provides Text-to-Speech (TTS) capabilities native to iOS and Android.
    *   **Configuration:** Uses the `en-US` locale with a customized speech rate (`0.5`) to ensure the spoken translation is clear and understandable.
5.  **`permission_handler`**
    *   Ensures the app gracefully requests and secures runtime access to the device camera before initializing the stream.

---

## 🧠 Step-by-Step Execution Flow

The translation process happens continuously in real-time, executing several times per second based on the camera's framerate.

### Phase 1: Frame Ingestion (`GestureScreen`)
The process begins in the UI layer. When the screen loads, the `CameraController` starts an image stream:
```dart
await _cameraController!.startImageStream(_processCameraImage);
```
Every single frame captured by the camera is immediately passed to the `_processCameraImage` function. To prevent memory leaks and UI stuttering, a boolean flag (`_isDetecting`) ensures that a new frame is only processed if the previous frame has finished processing.

### Phase 2: ML Feature Extraction (MediaPipe)
The raw camera frame (`CameraImage`) is sent to the `hand_landmarker` plugin alongside the sensor orientation data.
The ML model returns a `List<Hand>`. If a hand is detected, the system extracts the **21 landmarks**.

**The Coordinate System:**
MediaPipe returns normalized coordinates:
*   **X and Y** are normalized to `[0.0, 1.0]` based on the image width and height.
*   **Top of screen:** `Y = 0.0`
*   **Bottom of screen:** `Y = 1.0`

### Phase 3: Heuristic Logic Evaluation (`GestureService`)
Once the coordinates are extracted, they are passed to the `GestureService.detectGesture(List<Hand> hands)` method. Because the ML model only gives us *points in space*, we must use mathematical heuristics to figure out what those points represent (e.g., is a finger folded or extended?).

The logic relies on comparing the **Tip** of a finger to its corresponding **PIP** (Proximal Interphalangeal joint - the middle knuckle).

**Detailed Finger-Up Logic:**
Because `Y = 0` is the top of the screen, a finger is pointing "UP" if its Tip's Y-coordinate is *less than* its PIP's Y-coordinate.

*   **Thumb:** Tip (Index 4) vs IP joint (Index 3)
    *   `bool thumb = landmarks[4].y < landmarks[3].y;`
*   **Index Finger:** Tip (Index 8) vs PIP (Index 6)
    *   `bool index = landmarks[8].y < landmarks[6].y;`
*   **Middle Finger:** Tip (Index 12) vs PIP (Index 10)
    *   `bool middle = landmarks[12].y < landmarks[10].y;`
*   **Ring Finger:** Tip (Index 16) vs PIP (Index 14)
    *   `bool ring = landmarks[16].y < landmarks[14].y;`
*   **Pinky Finger:** Tip (Index 20) vs PIP (Index 18)
    *   `bool pinky = landmarks[20].y < landmarks[18].y;`

**Pattern Matching:**
The app counts how many non-thumb fingers are currently "UP" (count from 0 to 4) and combines that with the boolean state of the thumb to output a specific string mask:

*   **"Hello / 5":** Count == 4 (all fingers up) AND Thumb is Up.
*   **"Yes (Fist)":** Count == 0 (all fingers folded) AND Thumb is folded.
*   **"1":** Count == 1 AND only the Index finger is Up.
*   **"Peace / 2":** Count == 2 AND Index + Middle are Up.
*   **"3":** Count == 3 AND Index + Middle + Ring are Up.
*   **"4":** Count == 4 AND Thumb is folded.
*   **"Thumbs Up":** Count == 0 (all fingers folded) AND Thumb is Up.

### Phase 4: State Update and Vocalization (`TTSService`)
If the `GestureService` returns a gesture (e.g., "Hello / 5"), the UI receives this string. 

To prevent the text-to-speech engine from stuttering and repeating "Hello Hello Hello" 30 times a second, the app implements basic **debounce/state management**:
1.  It checks if the newly detected gesture matches the currently displayed `_recognizedText`.
2.  If it is a **new** gesture (and isn't the fallback "Detecting..." state), it triggers `setState()` to update the big text on the UI.
3.  Simultaneously, if the Voice toggle is enabled, it sends the string to `TTSService.speak()`.
4.  Inside `TTSService`, it checks the `_lastSpoken` variable. It only commands the OS to synthesize audio if the text is different from what was most recently spoken, finalized by `_flutterTts.speak(text)`.
