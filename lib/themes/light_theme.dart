import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blue.shade500,
    secondary: Colors.blueAccent.shade400,
    tertiary: Colors.blue.shade700,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.blue,
  ),
  textTheme: TextTheme(
    // for headlines
    headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
    // for body text
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
    // for lists and courses
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
    // labels are used for text fields
    labelLarge: TextStyle(fontSize: 16, color: Colors.black),
    labelMedium: TextStyle(fontSize: 16, color: Colors.black87),
    labelSmall: TextStyle(fontSize: 16, color: Colors.black54),
  ),
);
