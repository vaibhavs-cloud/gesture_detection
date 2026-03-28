import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  String? _lastSpoken;

  TTSService() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    if (text.isEmpty || text == _lastSpoken) return;
    
    _lastSpoken = text;
    await _flutterTts.speak(text);
  }

  void stop() async {
    await _flutterTts.stop();
  }
}
