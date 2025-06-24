// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// ThemeData mainTheme = ThemeData(
//   brightness: Brightness.dark,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   cardTheme: const CardTheme(
//     color: color: Color(0xffF5F5F5),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//       side: BorderSide(color: Colors.transparent, width: 2),
//     ),
//     elevation: 0,
//   ),
//   listTileTheme: const ListTileThemeData(iconColor: Colors.white),
//   scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//   inputDecorationTheme: const InputDecorationTheme(
//     labelStyle: TextStyle(color: Color(0xffffffff)),
//     helperStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//     hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//     prefixIconColor: Color.fromARGB(255, 255, 255, 255),
//     filled: true,
//     isDense: true,
//     fillColor: Color(0xff1F212E),
//     hoverColor: Colors.black,
//     border: InputBorder.none,
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(8.0)),
//       borderSide: BorderSide(color: Color(0xff1F212E)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(8.0)),
//       borderSide: BorderSide(color: Color(0xffFF6900)),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(8.0)),
//       borderSide: BorderSide(color: Color(0xffFF6900)),
//     ),
//   ),
//   bottomAppBarTheme: const BottomAppBarTheme(
//     color: Color(0xFF0E0E0E),
//     elevation: 0,
//   ),
//   //done
//   appBarTheme: const AppBarTheme(
//     foregroundColor: Colors.white,
//     backgroundColor: Color(0xFF0E0E0E),
//     elevation: 0,
//     systemOverlayStyle: SystemUiOverlayStyle(
//       statusBarColor: Color(0xff0C0D16),
//       statusBarIconBrightness: Brightness.light, // For Android (dark icons)
//       statusBarBrightness: Brightness.dark, // For iOS (dark icons)
//     ),
//     iconTheme: IconThemeData(
//       color: Colors.white,
//     ),
//   ),
//   primaryColor: const Color(0xffE5B66A),
//   primaryColorDark: const Color(0xffC7984C),
//   colorScheme: const ColorScheme(
//     background: Color(0xff0C0D16),
//     brightness: Brightness.dark,
//     onBackground: Colors.white,
//     primary: Color(0xffFF6900),
//     onPrimary: Colors.white,
//     secondary: Color(0xff2561ED),
//     onSecondary: Colors.white,
//     surface: Colors.white,
//     onSurface: Color(0xff1a1a1a),
//     error: Color(0xffFD4C62),
//     onError: Colors.white,
//   ),
//   fontFamily: "Manrope",
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     elevation: 0,
//     backgroundColor: Color(0xffFD4C62),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(16)),
//     ),
//     foregroundColor: Colors.white,
//   ),
//   //done
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: Color(0xFF0E0E0E),
//     elevation: 0,
//     selectedItemColor: Color(0xff2dadc2),
//   ),
// );


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData mainTheme = ThemeData(
  iconTheme: IconThemeData(
    color: Color(0xFF7717E8), // Applique à toutes les icônes
    size: 24,
  ),
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  cardTheme: const CardThemeData(
    color: Color(0xFFF5F5F5), // Gris clair pour contraste
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
    elevation: 2,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Color(0xFF333333), // Texte foncé
  ),
  scaffoldBackgroundColor: Colors.grey.shade200, // Blanc pur
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Color(0xFF7717E8)), // Violet primaire
    helperStyle: TextStyle(color: Color(0xFF666666)),
    hintStyle: TextStyle(color: Color(0xFF999999)),
    prefixIconColor: Color(0xFF7717E8),
    filled: true,
    isDense: true,
    fillColor: Color(0xFFF8F8F8), // Fond gris très clair
    hoverColor: Color(0xFFEEEEEE),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFDDDDDD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFF7717E8)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFE53935)),
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFFFFFFFF), // Blanc
    elevation: 5,
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Color(0xFFFFFFFF), // Texte foncé
    backgroundColor: Color(0xFF7717E8), // Blanc
    elevation: 5,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF), // Blanc
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF7717E8), // Applique à toutes les icônes
      size: 24,
    ),
  ),
  primaryColor: const Color(0xFF7717E8), // Violet primaire
  primaryColorDark: const Color(0xFF2AD2C9), // Violet foncé
  colorScheme: const ColorScheme(
    background: Color(0xFFFFFFFF), // Blanc
    brightness: Brightness.light, // Adapté au fond clair
    onBackground: Color(0xFF333333), // Texte principal
    primary: Color(0xFF7717E8),
    onPrimary: Color(0xFFFFFFFF), // Texte sur violet
    secondary: Color(0xFF666666), // Gris moyen
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFF8F8F8), // Fond de surface
    onSurface: Color(0xFF333333),
    error: Color(0xFFE53935), // Rouge vif
    onError: Color(0xFFFFFFFF),
  ),
  fontFamily: "Manrope",
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 4,
    backgroundColor: Color(0xFF7717E8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  foregroundColor: Color(0xFFFFFFFF),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 4,
    selectedItemColor: Color(0xFF7717E8),
  ),
);

