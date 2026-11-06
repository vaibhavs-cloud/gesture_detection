# SignAI Testing & Run Guide

This document outlines how to run the SignAI Flutter application and details the testing strategies to ensure the machine learning pipeline and user interface function correctly.

---

## 🚀 How to Run the Project

### Prerequisites
1. **Flutter SDK:** Ensure you have Flutter version `>=3.2.0 <4.0.0` installed.
2. **Android Studio / Xcode:** Required for mobile emulation or physical device deployment.
3. **Windows Developer Mode:** If you are building on Windows, you **must enable Developer Mode** in your system settings (Settings > Privacy & security > For developers). The `tflite_flutter` package needs this to create native symlinks during the build process.

### Running the App
1. Open a terminal and navigate to the project root:
   ```bash
   cd c:\Users\Vaibhav\projects\for_help\untitled2\untitled2
   ```
2. Fetch dependencies (Requires Developer Mode on Windows):
   ```bash
        flutter pub get
   ```
3. Connect a physical Android/iOS device or start an emulator. *(Note: Camera plugins require a physical device or a well-configured emulator with webcam passthrough).*
4. Build and run the app:
   ```bash
   flutter run
   ```

---

## 🧪 Comprehensive Testing Strategy

Because this application relies on a hardware camera, live native dependencies (`flutter_tts`), and an on-device ML model (`tflite_flutter`, `hand_landmarker`), tests are divided into **Manual ML Validations** and **Automated Tests**.

### 1. Manual Validation Tests (The Core ML Pipeline)

Automated tests cannot fully replicate real-time camera feeds or varying lighting conditions. The following must be tested manually:

*   **Test 1: Model Loading & Initialization**
    *   *Action:* Launch the `GestureScreen`.
    *   *Expected:* The camera starts, and the UI shifts from "Starting AI Camera..." to "Waiting for Gesture...". Check the console logs for `TFLite model loaded successfully`.
*   **Test 2: Asset Fallback (Heuristic Mode)**
    *   *Action:* Temporarily rename `assets/keypoint_classifier.tflite` to `broken.tflite`, then rebuild the app. Point your camera and perform the following exact gestures:
        *   **"4"**: Hold up 4 fingers (index, middle, ring, pinky) with the thumb folded in.
        *   **"Hello / 5"**: Hold up all 5 fingers open.
        *   **"Yes (Fist)"**: Fold all 5 fingers into a tight fist.
        *   **"1"**: Hold up only the index finger.
        *   **"Peace / 2"**: Hold up only the index and middle fingers.
        *   **"3"**: Hold up the index, middle, and ring fingers.
        *   **"Thumbs Up"**: Fold all fingers (index through pinky) but leave the thumb sticking up.
    *   *Expected:* The console logs `TFLite load failed, falling back to heuristics`. The UI should reliably classify all the hardcoded heuristic gestures listed above based on the finger-joint mathematics.
*   **Test 3: TFLite Inference Accuracy (Demonstration Model)**
    *   *Action:* Make sure `keypoint_classifier.tflite` is loaded, launch the app, and perform the following exact gestures over the camera:
        *   **Open Hand**: Extend all 5 fingers completely open and spread apart.
        *   **Closed Fist**: Fold all fingers inward into a tight fist.
        *   **Pointing**: Fold the thumb, middle, ring, and pinky fingers, leaving only the index finger pointing outward/upward.
    *   *Expected:* The UI should successfully classify and transition between the ML labels: `Open`, `Close`, and `Pointer`.

*   **Test 4: Training the Full ASL Dataset (Next Steps)**
    *   *Context:* You have added `assets/asl_mediapipe_keypoints_dataset (1).csv`. This is a **raw training dataset** containing over 50,000 rows of hand landmarks for the entire alphabet, not a compiled Flutter model.
    *   *Action:* Before the app can recognize 26 letters, you must train a Neural Network on this CSV using a Python script or Jupyter Notebook (like the Kazuhito00 training notebook).
    *   *Expected:* Once trained, export the resulting model as a new `keypoint_classifier.tflite` file and replace the demo one in your `assets/` folder. Update your `keypoint_classifier_label.csv` to list `A, B, C...` and your app will instantly support the entire alphabet.
*   **Test 5: TTS Integration**
    *   *Action:* Enable the "Voice On" button and perform a recognized gesture.
    *   *Expected:* The app speaks the recognized text (e.g., "Open") exactly once, successfully debouncing repeated frames.

### 2. Automated Unit Testing

You can verify the mathematical correctness of your services using Flutter's test framework. Create a `test/` folder and implement the following logic:

*   **Old Heuristic Service Tests (`test/gesture_service_test.dart`)**
    *   Pass mock MediaPipe `Landmark` lists (simulating a folded thumb and 4 raised fingers).
    *   Assert that `GestureService.detectGesture()` returns exactly `"4"`.
*   **TFLite Pre-processing Tests (`test/tflite_service_test.dart`)**
    *   The `TFLiteService.classify()` method flattens and normalizes coordinates relative to the wrist.
    *   Pass a mock `List<Landmark>` and assert that the resulting flattened `List<double>` contains exactly 42 elements, with values constrained between `-1.0` and `1.0`.

### 3. Automated Widget / UI Testing

UI Testing ensures the application state changes correctly without needing the camera.

*   **State Debouncing (`test/gesture_screen_widget_test.dart`)**
    *   Mock the `TFLiteService` to return "Open" 100 times in a row.
    *   Assert that the UI updates the text to "Open", but verify via mocks that `TTSService.speak()` was only invoked *once*.
*   **Permissions Handling**
    *   Mock `Permission.camera.request()` to return `Denied`.
    *   Assert that the screen displays `"Camera Permission Denied"` instead of attempting to load the camera controller.

### 4. Running Automated Tests

To run unit and widget tests (once created in the `test/` directory):

```bash
flutter test
```
