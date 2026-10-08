import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData lightTheme = ThemeData(
  hintColor: myGreenAccent,
  primaryColor: myGreen,
  //font size and style for all text widgets
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
    //
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    titleSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    //
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  ),
  iconTheme: IconThemeData(color: myGreen, size: 24),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: myGreen,
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return myGreen; // checked background
      }
      return Colors.white; // unchecked background
    }),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white; // check icon color when checked
      }
      return Colors.transparent; // no check when unchecked
    }),
    side: const BorderSide(color: Colors.grey), // border when unchecked
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.black,
    backgroundColor: Color.fromARGB(255, 216, 237, 227).withValues(alpha: .5),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    elevation: 0,
    centerTitle: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
  cardTheme: const CardThemeData(color: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: myGreen,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      minimumSize: Size(double.infinity, 40),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    textColor: Colors.black,
    titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    subtitleTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: myGreen,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withValues(alpha: 0.7),
    type: BottomNavigationBarType.fixed,
  ),
);
