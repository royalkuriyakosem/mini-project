import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;
  
  bool _isDarkMode = false;
  bool _isVoiceCommandEnabled = false;
  double _speechRate = 1.0;
  double _speechPitch = 1.0;

  bool get isDarkMode => _isDarkMode;
  bool get isVoiceCommandEnabled => _isVoiceCommandEnabled;
  double get speechRate => _speechRate;
  double get speechPitch => _speechPitch;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _isVoiceCommandEnabled = _prefs.getBool('voiceCommand') ?? false;
    _speechRate = _prefs.getDouble('speechRate') ?? 1.0;
    _speechPitch = _prefs.getDouble('speechPitch') ?? 1.0;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleVoiceCommand() async {
    _isVoiceCommandEnabled = !_isVoiceCommandEnabled;
    await _prefs.setBool('voiceCommand', _isVoiceCommandEnabled);
    notifyListeners();
  }

  void setSpeechRate(double rate) {
    _speechRate = rate;
    _prefs.setDouble('speechRate', rate);
    notifyListeners();
  }

  void setSpeechPitch(double pitch) {
    _speechPitch = pitch;
    _prefs.setDouble('speechPitch', pitch);
    notifyListeners();
  }
} 