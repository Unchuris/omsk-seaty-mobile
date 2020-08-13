import 'package:flutter/material.dart';

ThemeData lightTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 17.0,
        color: Color(0xFF4F4F4F),
      ),
      headline6: base.headline6.copyWith(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: Colors.white,
      ),
      subtitle1: base.subtitle1.copyWith(
          fontFamily: 'Rotobo',
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
          color: Colors.white),
      bodyText1: base.bodyText1.copyWith(
          fontFamily: 'Rotobo',
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          color: Colors.black),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    scaffoldBackgroundColor: Color(0xFFC4C4C4),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    primaryColor: Colors.white,
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
  );
}
