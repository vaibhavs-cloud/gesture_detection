# ASL Pretrained Model Integration Guide

Pivoting from rule-based logic to a pretrained Machine Learning model for **American Sign Language (ASL)** is the fastest way to get a fully working ML pipeline in your Flutter app. Because ASL is widely researched, you do not need to train your own model from scratch.

---

## 🚀 Step 1: Obtain a Pretrained ASL `.tflite` Model
Instead of training a neural network in Python, you simply download weights that someone else has already trained.

### Where to find them:
1.  **GitHub:** Search for "MediaPipe Hand Gesture TFLite model". A highly recommended repository is [Kazuhito00's Hand Gesture Recognition](https://github.com/Kazuhito00/hand-gesture-recognition-using-mediapipe). He provides a ready-to-use `.tflite` file for basic ASL signs and numbers.
2.  **Kaggle:** Search "ASL TFLite". Many winners from the "Google - Isolated Sign Language Recognition" competition have public, highly-optimized `.tflite` files you can download.

The file you are looking for will usually be named something like `keypoint_classifier.tflite` or `asl_model.tflite`.

---

## 🛠️ Step 2: Add the Model to Your Flutter Project

1.  Create an `assets/` folder in the root of your project (`untitled2/assets/`).
2.  Drop your downloaded `asl_model.tflite` and the accompanying `labels.txt` (a text file listing the ASL words the model knows, like A, B, C, Hello, Thanks) into that folder.
3.  Update your `pubspec.yaml` to include the assets:
```yaml
flutter:
  assets:
    - assets/asl_model.tflite
    - assets/labels.txt
```

---

## 📦 Step 3: Install the TFLite Flutter Plugin

You need a way for Dart to "read" the `.tflite` file and run predictions. Run this command in your terminal:

```bash
flutter pub add tflite_flutter
```

*(Note: Ensure you follow any extra setup steps for Android/iOS required by `tflite_flutter` on their pub.dev page).*

---

## 🧠 Step 4: Refactor Your Flutter Code

Currently, your `GestureService.dart` uses `if/else` statements. You will replace this service with a **TFLite Inference Service**.

### The High-Level Logic Change:

**Old Flow (Heuristics):**
`Camera Frame` ➡️ `MediaPipe` ➡️ `Get 21 Landmarks` ➡️ `Compare Y coordinates in IF statements` ➡️ `Output "Hello"`

**New Flow (Machine Learning):**
`Camera Frame` ➡️ `MediaPipe` ➡️ `Get 21 Landmarks` ➡️ `Feed Coordinates array into TFLite Interpreter` ➡️ `Interpreter outputs array of probabilities` ➡️ `Output highest probability label ("Hello")`

### Code Implementation Example

When you load your app, you will initialize the interpreter:

```dart
import 'package:tflite_flutter/tflite_flutter.dart';

late Interpreter _interpreter;
List<String> _labels = [];

Future<void> loadModel() async {
  // Load the downloaded pre-trained weights
  _interpreter = await Interpreter.fromAsset('assets/asl_model.tflite');
  // Load the text file that says [0 = A, 1 = B, 2 = C...]
  _labels = await _loadLabels('assets/labels.txt');
}
```

In your `_processCameraImage` loop, instead of calling `GestureService.detectGesture`, you format the coordinates and run inference:

```dart
// 1. MediaPipe gives you the landmarks
final hands = _plugin!.detect(image, orientation);
if (hands.isEmpty) return;
final landmarks = hands.first.landmarks;

// 2. Flatten the 21 landmarks into the 1D array the model expects
// (Usually [x1, y1, x2, y2... x21, y21])
List<double> inputCoordinates = [];
for (var point in landmarks) {
    inputCoordinates.add(point.x);
    inputCoordinates.add(point.y);
}

// 3. Create the output array (e.g., if model knows 26 letters, it returns 26 probabilities)
var output = List<double>.filled(26, 0).reshape([1, 26]);

// 4. Run the TFLite model!
_interpreter.run([inputCoordinates], output);

// 5. Find the index with the highest probability
int highestProbIndex = _getHighestIndex(output[0]);
String predictedSign = _labels[highestProbIndex];

// 6. Send to TTS!
_onGestureDetected(predictedSign);
```

### Why this is better:
By dropping in a `.tflite` file, your app instantly becomes infinitely scalable. If you want the app to learn 100 new ASL signs, you don't write 100 new `if/else` blocks; you just download a better `.tflite` file and replace the old one in your `assets/` folder. No Dart code needs to change!
