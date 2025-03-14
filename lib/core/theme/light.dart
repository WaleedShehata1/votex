import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

ThemeData light({Color color = const Color(0xFF218cd0)}) => ThemeData(
      // useMaterial3: false, // Uncomment if necessary
      fontFamily: AppConstants.fontFamily,
      primaryColor: color,
      hoverColor: const Color(0xff0F0F31),
      secondaryHeaderColor: const Color(0xFF102e52),
      disabledColor: const Color(0xFFf3f3f3),
      brightness: Brightness.light,
      hintColor: const Color(0xFF9F9F9F),
      cardColor: Colors.white,
      scaffoldBackgroundColor:
          Colors.white, // Changed to scaffoldBackgroundColor
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.light(primary: color, secondary: color)
          .copyWith(surface: Colors.white)
          .copyWith(error: const Color(0xFFE84D4F)),
    );

ThemeData dark({Color color = const Color(0xFF6B65BD)}) => ThemeData(
      // useMaterial3: false, // Uncomment if necessary
      fontFamily: AppConstants.fontFamily,
      primaryColor: color,
      hoverColor: const Color(0xFF000000),
      secondaryHeaderColor: const Color(0xFF102e52),
      disabledColor: const Color.fromARGB(255, 0, 0, 0),
      brightness: Brightness.light,
      hintColor: const Color(0xFF9F9F9F),
      cardColor: Colors.black,
      scaffoldBackgroundColor:
          Colors.black, // Changed to scaffoldBackgroundColor
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.light(primary: color, secondary: color)
          .copyWith(surface: Colors.black)
          .copyWith(error: const Color(0xFFE84D4F)),
    );
