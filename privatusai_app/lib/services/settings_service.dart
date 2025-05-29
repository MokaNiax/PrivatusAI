import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String? _aiApiKey;
  String _aiServiceType = 'OpenAI';
  String _aiModel = 'gpt-3.5-turbo';
  Color _lightModePrimaryColor = const Color(0xFFF0D1C2);
  Color _lightModeAccentColor = Colors.white;
  Color _darkModePrimaryColor = const Color(0xFF181818);
  Color _darkModeAccentColor = const Color(0xFF222222);
  List<String> _customPrompts = ['Hello World!'];
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  String? get aiApiKey => _aiApiKey;
  String get aiServiceType => _aiServiceType;
  String get aiModel => _aiModel;
  Color get lightModePrimaryColor => _lightModePrimaryColor;
  Color get lightModeAccentColor => _lightModeAccentColor;
  Color get darkModePrimaryColor => _darkModePrimaryColor;
  Color get darkModeAccentColor => _darkModeAccentColor;
  List<String> get customPrompts => List.unmodifiable(_customPrompts);
  Locale get locale => _locale;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == prefs.getString('themeMode'),
      orElse: () => ThemeMode.system,
    );
    _aiApiKey = prefs.getString('aiApiKey');
    _aiServiceType = prefs.getString('aiServiceType') ?? 'OpenAI';

    List<String> availableModels = getModelsForService(_aiServiceType);

    String? savedModel = prefs.getString('aiModel');
    if (savedModel != null && availableModels.contains(savedModel)) {
      _aiModel = savedModel;
    } else if (availableModels.isNotEmpty) {
      _aiModel = availableModels.first;
    } else {
      _aiModel = 'gpt-3.5-turbo';
    }

    _lightModePrimaryColor = Color(prefs.getInt('lightModePrimaryColor') ?? _lightModePrimaryColor.value);
    _lightModeAccentColor = Color(prefs.getInt('lightModeAccentColor') ?? _lightModeAccentColor.value);
    _darkModePrimaryColor = Color(prefs.getInt('darkModePrimaryColor') ?? _darkModePrimaryColor.value);
    _darkModeAccentColor = Color(prefs.getInt('darkModeAccentColor') ?? _darkModeAccentColor.value);
    _customPrompts = prefs.getStringList('customPrompts') ?? ['Hello World!'];
    _locale = Locale(prefs.getString('languageCode') ?? 'en');
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeMode.toString());
    if (_aiApiKey != null) {
      await prefs.setString('aiApiKey', _aiApiKey!);
    } else {
      await prefs.remove('aiApiKey');
    }
    await prefs.setString('aiServiceType', _aiServiceType);
    await prefs.setString('aiModel', _aiModel);
    await prefs.setInt('lightModePrimaryColor', _lightModePrimaryColor.value);
    await prefs.setInt('lightModeAccentColor', _lightModeAccentColor.value);
    await prefs.setInt('darkModePrimaryColor', _darkModePrimaryColor.value);
    await prefs.setInt('darkModeAccentColor', _darkModeAccentColor.value);
    await prefs.setStringList('customPrompts', _customPrompts);
    await prefs.setString('languageCode', _locale.languageCode);
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    saveSettings();
    notifyListeners();
  }

  void setAiApiKey(String? key) {
    _aiApiKey = key;
    saveSettings();
    notifyListeners();
  }

  void setAiServiceType(String type) {
    if (_aiServiceType != type) {
      _aiServiceType = type;
      _aiModel = _getDefaultModelForService(type);
      saveSettings();
      notifyListeners();
    }
  }

  void setAiModel(String model) {
    _aiModel = model;
    saveSettings();
    notifyListeners();
  }

  void setLightModeColors(Color primary, Color accent) {
    _lightModePrimaryColor = primary;
    _lightModeAccentColor = accent;
    saveSettings();
    notifyListeners();
  }

  void setDarkModeColors(Color primary, Color accent) {
    _darkModePrimaryColor = primary;
    _darkModeAccentColor = accent;
    saveSettings();
    notifyListeners();
  }

  void addCustomPrompt(String prompt) {
    _customPrompts.add(prompt);
    saveSettings();
    notifyListeners();
  }

  void updateCustomPrompt(int index, String newPrompt) {
    if (index >= 0 && index < _customPrompts.length) {
      _customPrompts[index] = newPrompt;
      saveSettings();
      notifyListeners();
    }
  }

  void removeCustomPrompt(int index) {
    if (index >= 0 && index < _customPrompts.length) {
      _customPrompts.removeAt(index);
      saveSettings();
      notifyListeners();
    }
  }

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      saveSettings();
      notifyListeners();
    }
  }

  String _getDefaultModelForService(String serviceType) {
    List<String> models = getModelsForService(serviceType);
    if (models.isNotEmpty) {
      return models.first;
    }
    return 'gpt-3.5-turbo';
  }

  List<String> getModelsForService(String serviceType) {
    switch (serviceType) {
      case 'OpenAI':
        return [
          'gpt-3.5-turbo',
          'gpt-4o',
          'gpt-4-turbo'
        ];
      case 'Gemini':
        return [
          'gemini-2.5-flash-preview-05-20',
          'gemini-2.5-pro-preview-05-06',
          'gemini-2.0-flash',
          'gemini-2.0-flash-lite',
          'gemini-1.5-flash',
          'gemini-1.5-flash-8b',
          'gemini-1.5-pro',
        ];
      default:
        return ['default-model'];
    }
  }
}