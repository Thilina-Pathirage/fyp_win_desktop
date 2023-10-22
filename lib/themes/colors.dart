import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff4364d0);
  static const Color secondaryColor = Colors.white;
  static const Color secondaryColor54 = Colors.white54;
  static const Color secondaryColor38 = Colors.white38;
  static const Color textColorLight = Colors.black;
  static const Color succeessColor = Colors.green;
  static const Color editColor = Color(0xff0066FF);
  static const Color errorColor = Color.fromARGB(255, 255, 48, 48);
  static const Color textColorDark = Colors.white;
  static const Color ashColor = Color(0xffF3F3F3);
  static const Color greyColor = Color.fromARGB(255, 97, 97, 97);

  static const LinearGradient borderColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFFFD700)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient inputGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Colors.white],
  );
}
