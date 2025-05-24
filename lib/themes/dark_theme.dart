import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.grey.shade900,
      secondary: Colors.grey.shade700,
      tertiary: Colors.grey.shade500,
      onPrimary: Colors.white,
      onSecondary: Colors.white70,
      onSurface: Colors.white60,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.blue.shade500,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
      headlineSmall: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white60),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
      bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
      titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      titleMedium: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
      titleSmall: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white60),
      labelLarge: TextStyle(fontSize: 16, color: Colors.white),
      labelMedium: TextStyle(fontSize: 16, color: Colors.white70),
      labelSmall: TextStyle(fontSize: 16, color: Colors.white54),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade700,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white54),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade500),
      ),
      labelStyle: TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white60),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black54,
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.grey.shade300),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue.shade700;
        }
        return Colors.grey.shade600;
      }),
      overlayColor: WidgetStateProperty.all(Colors.blue.shade800),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey.shade800,
      contentTextStyle: TextStyle(color: Colors.white70),
      actionTextColor: Colors.blue.shade500,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey.shade900),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      textStyle: TextStyle(color: Colors.white70),
    ));
