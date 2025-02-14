import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AccessibilityService {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  Future<void> initialize() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(1.0);
    await _speechToText.initialize();
  }

  Future<void> speak(String text, double rate) async {
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_isListening) {
      _isListening = await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    }
  }

  void stopListening() {
    _speechToText.stop();
    _isListening = false;
  }

  bool get isListening => _isListening;
} 