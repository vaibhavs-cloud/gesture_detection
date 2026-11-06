# Scaling SignAI to Full Indian Sign Language (ISL)

To expand this system to understand the **entire Indian Sign Language (ISL)**, we must fundamentally change how the system classifies gestures. 

## The Challenge with ISL
ISL is significantly different and often more complex than standard American Sign Language (ASL) alphabets:
1.  **Two-Handed Requirement:** Unlike ASL alphabets, ISL heavily relies on **both hands** interacting with each other.
2.  **Dynamic Motion:** Most actual words (verbs, nouns) in ISL require movement over time (e.g., bringing hands together, rotating wrists), not just a static pose.
3.  **Facial Context:** True sign language relies on facial expressions to convey grammar and tone.

## Why the Current "Heuristic" Approach Fails
Currently, the app uses **heuristics** (IF / ELSE rules based on which finger is above a joint). 
Writing IF/ELSE rules for 10,000+ ISL signs involving two moving hands is impossible. The system must transition from **Hardcoded Rules** to **Machine Learning (Data-Driven)**.

---

## The Easiest & Most Viable Path: LSTM / Sequence Modeling

To recognize moving ISL signs, the easiest, most lightweight, and mobile-friendly approach is training a recurrent neural network on MediaPipe landmark data.

### Step 1: Upgrade the Hand Tracker
In `GestureScreen`, update the `numHands` property of `hand_landmarker` to **2**.
```dart
HandLandmarkerPlugin.create(
  numHands: 2, // Crucial for ISL
  // ...
)
```
*Optional but recommended:* Integrate MediaPipe **Pose** tracking to capture arm and body movements.

### Step 2: Dataset Collection (The Hard Part)
You cannot train the model on raw videos (it's too heavy for mobile). Instead, you record the **MediaPipe Landmarks** of ISL gestures.
1.  Record someone performing ISL signs.
2.  Extract the MediaPipe X, Y, Z coordinates for both hands (42 points total) for every frame of the video.
3.  Save this data into CSV/JSON files over a timespan (e.g., 30 frames = 1 sign).

### Step 3: Train an LSTM Model (in Python)
Using Python and TensorFlow/Keras, train a Long Short-Term Memory (LSTM) network. LSTMs are specifically designed to understand "Time-Series" data (frames of movement).
*   **Input:** Sequences of 30 frames containing 42 landmark coordinates.
*   **Model:** A simple LSTM with a few Dense layers.
*   **Output:** Softmax probabilities of the ISL vocabulary (e.g., "Thank You", "Water", "Hello").

### Step 4: Export to TensorFlow Lite (`.tflite`)
Once the Python model is highly accurate, convert it into a TensorFlow Lite `.tflite` file. This format is highly compressed and runs instantly on mobile phones.

### Step 5: Run Inference in Flutter
Remove the `GestureService` rule-based logic and replace it with the TensorFlow Lite Flutter plugin (`tflite_flutter`).
1.  Pass the last 30 frames of MediaPipe coordinates into the `.tflite` model.
2.  The model returns a prediction (e.g., "95% confidence this is 'Water'").
3.  Send "Water" to the TTS engine.

---

## Recommended Roadmap for Implementation

Scaling to full ISL is a massive undertaking. Here is the easiest way to break it down:

*   **Phase 1: Static ISL Alphabets**
    *   Track 2 hands. 
    *   Train a standard Neural Network (no time tracking needed, just a single frame) on a CSV of hand coordinates for A-Z in ISL.
*   **Phase 2: Basic ISL Action Words (Dynamic)**
    *   Pick 10 common moving ISL signs (Hello, Thank You, Sorry, Please, Help).
    *   Collect 50-100 video samples for each word.
    *   Train a basic LSTM pipeline and get it running in Flutter.
*   **Phase 3: Scaling Up**
    *   Automate data collection using existing ISL datasets (like INCLUDE dataset).
    *   Expand to hundreds of words and add MediaPipe Pose to capture arm geometry.
