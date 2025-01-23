import 'package:flutter/material.dart';

class ThemeStyle {
  //production
  static Color blueColor = const Color(0xFF12509D);
  static double font1 = 14;

  static TextStyle labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 90, 90, 90));

  static TextStyle outputStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 32, 32, 32));

  static TextStyle smallOutputStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
      color: Color.fromARGB(255, 32, 32, 32));

  static Widget customCard(Widget child) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 2,
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}
