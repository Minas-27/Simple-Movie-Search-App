import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFF4A90E2);
final Color secondaryColor = Color(0xFF50E3C2);
final Color backgroundColor = Color(0xFFF5F5F5);
final Color textColor = Color(0xFF333333);

final Color darkBackgroundColor = Color(0xFF121212);
final Color darkTextColor = Colors.white;

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: textColor),
    bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    filled: true,
    fillColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      minimumSize: Size(double.infinity, 50),
    ),
  ),
);

ThemeData darkAppTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: darkBackgroundColor,
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: darkTextColor,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: darkTextColor),
    bodySmall: TextStyle(fontSize: 14, color: Colors.white70),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    filled: true,
    fillColor: Colors.grey[900],
    hintStyle: TextStyle(color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      minimumSize: Size(double.infinity, 50),
    ),
  ),
);

/// Global theme state
ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.light);

/// Toggle dark/light mode
void toggleThemeMode(bool isDark) {
  appThemeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
}
