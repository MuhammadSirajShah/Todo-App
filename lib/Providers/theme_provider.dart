import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isDarkMode  = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(){
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Light Gradient
  List<Color> get lightGradient => [
    Colors.teal,
    Colors.grey.shade100,
  ];

  // Dark Gradient

  List<Color> get darkGradient => [
     Color(0xFF121212),
     Color(0xFF1E1E1E),
  ];

}