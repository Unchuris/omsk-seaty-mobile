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
      headline5: base.headline5.copyWith(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: Color(0xff8E8E93),
      ),
      headline4: base.headline4.copyWith(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        color: Color(0xffC7C7CC),
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
          color: Color(0xff828282)),
      subtitle2: base.subtitle2.copyWith(
          fontFamily: 'Rotobo',
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
          color: Color(0xffBDBDBD)),
      bodyText1: base.bodyText1.copyWith(
          fontFamily: 'Rotobo',
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          color: Colors.black),
      bodyText2: base.bodyText2.copyWith(
          fontFamily: 'Rotobo',
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          color: Color(0x99000000)),
      button: base.button.copyWith(
          fontFamily: 'Rotobo',
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          color: Color(0xffF2994A)),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme),
      scaffoldBackgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      canvasColor: Colors.white,
      primaryColor: Color(0xffE0E0E0),
      buttonColor: Colors.white,
      backgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity);
}
