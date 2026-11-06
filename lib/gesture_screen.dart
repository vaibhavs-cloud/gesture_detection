import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hand_landmarker/hand_landmarker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'tflite_service.dart';
import 'gesture_service.dart';
import 'tts_service.dart';

class GestureScreen extends StatefulWidget {
  const GestureScreen({super.key});

  @override
  State<GestureScreen> createState() => _GestureScreenState();
}

class _GestureScreenState extends State<GestureScreen> {
  CameraController? _cameraController;
  HandLandmarkerPlugin? _plugin;
  final TTSService _ttsService = TTSService();
  final TFLiteService _tfliteService = TFLiteService();
  final GestureService _gestureService = GestureService(); // fallback
  bool _useTFLite = false;

  String _recognizedText = "Initializing...";
  bool _isVoiceEnabled = true;
  bool _isDetecting = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _recognizedText = "Camera Permission Denied");
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      setState(() => _recognizedText = "No Cameras Found");
      return;
    }

    // Prefer front camera for sign language
    final camera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // Initialize the HandLandmarker plugin
    _plugin = HandLandmarkerPlugin.create(
      numHands: 1,
      minHandDetectionConfidence: 0.6,
      delegate: HandLandmarkerDelegate.gpu,
    );

    try {
      await _cameraController!.initialize();

      // Load the TFLite model (fall back to heuristics on failure)
      try {
        await _tfliteService.loadModel();
        _useTFLite = true;
        debugPrint('TFLite model loaded successfully');
      } catch (e) {
        _useTFLite = false;
        debugPrint('TFLite load failed, falling back to heuristics: $e');
      }

      // Start the camera image stream and process each frame
      await _cameraController!.startImageStream(_processCameraImage);

      setState(() {
        _isInitialized = true;
        _recognizedText = "Waiting for Gesture...";
      });
    } catch (e) {
      setState(() => _recognizedText = "Camera Error: $e");
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    // Skip frame if already processing or not ready
    if (_isDetecting || !_isInitialized || _plugin == null) return;

    _isDetecting = true;

    try {
      // Use the hand_landmarker plugin's detect method.
      // It takes the raw CameraImage and the sensor orientation.
      final hands = _plugin!.detect(
        image,
        _cameraController!.description.sensorOrientation,
      );

      // Classify gesture using TFLite ML model or heuristic fallback
      String gesture;
      if (_useTFLite && hands.isNotEmpty) {
        gesture = _tfliteService.classify(hands.first.landmarks);
      } else {
        gesture = _gestureService.detectGesture(hands);
      }
      _onGestureDetected(gesture);
    } catch (e) {
      debugPrint('Error detecting landmarks: $e');
    } finally {
      _isDetecting = false;
    }
  }

  void _onGestureDetected(String gesture) {
    if (gesture != _recognizedText && gesture != "Detecting...") {
      setState(() {
        _recognizedText = gesture;
      });

      if (_isVoiceEnabled) {
        _ttsService.speak(gesture);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _plugin?.dispose();
    _tfliteService.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _cameraController == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF00796B)),
              SizedBox(height: 20),
              Text("Starting AI Camera..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text(
          "Real-Time Sign AI",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00796B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                Border.all(color: const Color(0xFF00796B), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(35)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5))
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "DETECTED GESTURE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _recognizedText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00796B),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      _controlButton(
                        icon: _isVoiceEnabled
                            ? Icons.volume_up
                            : Icons.volume_off,
                        label: _isVoiceEnabled
                            ? "Voice On"
                            : "Voice Off",
                        color: _isVoiceEnabled
                            ? const Color(0xFF00796B)
                            : Colors.grey,
                        onTap: () {
                          setState(() =>
                          _isVoiceEnabled = !_isVoiceEnabled);
                        },
                      ),
                      _controlButton(
                        icon: Icons.refresh,
                        label: "Reset",
                        color: Colors.orange,
                        onTap: () {
                          setState(
                                  () => _recognizedText = "Waiting...");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}