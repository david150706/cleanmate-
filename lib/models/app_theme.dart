import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xffAF87FF),
            fontSize: 30,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
          bodyLarge: TextStyle(
            color: Color(0xffE7DBFF),
            fontSize: 22,
          ),
          bodySmall: TextStyle(
            color: Colors.deepPurple,
            fontSize: 16,
          )),
      primarySwatch: Colors.deepPurple,
      primaryColor: Colors.black,
      backgroundColor: Colors.black,
      indicatorColor: Color(0xff0E1D36),
      hintColor: Color(0xff280C0B),
      highlightColor: Color(0xff372901),
      hoverColor: Color(0xff3A3A3B),
      focusColor: Color(0xff0B2512),
      disabledColor: Colors.grey,
      textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.white),
      cardColor: Color(0xFF151515),
      canvasColor: Colors.black,
      brightness: Brightness.dark,
      buttonTheme: Theme.of(context)
          .buttonTheme
          .copyWith(colorScheme: ColorScheme.dark()),
      appBarTheme:
          AppBarTheme(elevation: 0.0, backgroundColor: Colors.deepPurple),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 2,
        selectedIconTheme: IconThemeData(color: Colors.tealAccent),
        unselectedIconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
