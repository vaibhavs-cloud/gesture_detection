import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

/// Service that loads a TFLite keypoint classifier and runs inference
/// on MediaPipe hand landmarks to predict ASL gestures.
class TFLiteService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isReady = false;

  bool get isReady => _isReady;

  Future<void> loadModel() async {
    try {
      // Load the TFLite model
      try {
         _interpreter = await Interpreter.fromAsset('assets/keypoint_classifier.tflite');
      } catch (e) {
         _interpreter = await Interpreter.fromAsset('keypoint_classifier.tflite');
      }

      print('--- TFLITE MODEL LOADED ---');
      print('Input Tensors: ${_interpreter!.getInputTensors()}');
      print('Output Tensors: ${_interpreter!.getOutputTensors()}');
      print('---------------------------');

      // Load the labels file
      final labelData = await rootBundle.loadString(
        'assets/keypoint_classifier_label.csv',
      );
      _labels = labelData
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      _isReady = true;
    } catch (e) {
      print('Error loading TFLite model: $e');
      _isReady = false;
      rethrow;
    }
  }

  /// Takes the 21 MediaPipe hand landmarks and returns the predicted label.
  ///
  /// The Kazuhito00 keypoint_classifier model expects a 1D input of
  /// pre-processed landmark coordinates. The landmarks are flattened
  /// to [x1, y1, x2, y2, ..., x21, y21] and normalized relative to
  /// the wrist (landmark 0) so the model is translation-invariant.
  String classify(List<Landmark> landmarks) {
    if (!_isReady || _interpreter == null || landmarks.length < 21) {
      print('TFLiteService not ready. Ready: $_isReady, Interpreter: ${_interpreter != null}, length: ${landmarks.length}');
      return 'Detecting...';
    }

    // --- Pre-process: flatten & normalize relative to wrist ---
    final double baseX = landmarks[0].x;
    final double baseY = landmarks[0].y;

    List<double> coords = [];
    for (int i = 0; i < 21; i++) {
      coords.add(landmarks[i].x - baseX);
      coords.add(landmarks[i].y - baseY);
    }

    // Normalize to [-1, 1] range based on the max absolute value
    double maxVal = 0.0;
    for (var v in coords) {
      if (v.abs() > maxVal) maxVal = v.abs();
    }
    if (maxVal > 0) {
      coords = coords.map((v) => v / maxVal).toList();
    }

    // --- Run Inference ---
    // Input shape: [1, 42]
    final input = [coords];

    // Output shape: [1, numLabels]
    // Using List.generate to avoid strongly typed List<Float32List> which crashes tflite_flutter
    final output = List.generate(1, (i) => List.filled(_labels.length, 0.0));

    try {
      _interpreter!.run(input, output);
    } catch (e) {
      print('Interpreter run failed. Exception: $e');
      print('Provided input shape: ${input.length} x ${input[0].length}, type: ${input[0].runtimeType}');
      print('Expected input type: ${_interpreter!.getInputTensor(0).type}');
      return 'Error';
    }

    // --- Post-process: find the label with the highest probability ---
    final probabilities = output[0];
    print('TFLite Output Probabilities: $probabilities');
    int bestIndex = 0;
    double bestScore = probabilities[0];
    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > bestScore) {
        bestScore = probabilities[i];
        bestIndex = i;
      }
    }

    if (bestIndex < _labels.length) {
      return _labels[bestIndex];
    }
    return 'Unknown';
  }

  /// Releases the interpreter resources.
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isReady = false;
  }
}
