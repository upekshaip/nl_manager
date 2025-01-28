import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade500,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.blue.shade500,
  ),
  textTheme: TextTheme(
    // for headlines
    headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white60),
    // for body text
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
    // for lists and courses
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white60),
    // labels are used for text fields
    labelLarge: TextStyle(fontSize: 16, color: Colors.white),
    labelMedium: TextStyle(fontSize: 16, color: Colors.white70),
    labelSmall: TextStyle(fontSize: 16, color: Colors.white54),
  ),
);
