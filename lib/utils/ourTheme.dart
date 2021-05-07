import 'package:flutter/material.dart';

class OurTheme {
  
  Color _lightGreen = Color.fromARGB(255, 213, 235, 220);
  
  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: _lightGreen,
    );
  }
}
